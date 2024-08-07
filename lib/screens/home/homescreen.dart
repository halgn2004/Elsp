import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elsobkypack/checkfileinsplash/checkfilestart.dart';
import 'package:elsobkypack/checkuser/userlogin.dart';
import 'package:elsobkypack/database/database_helper.dart';
import 'package:elsobkypack/models/main_prod.dart';
import 'package:elsobkypack/screens/appdrawer.dart';
import 'package:elsobkypack/screens/about/aboutscreen.dart';
import 'package:elsobkypack/screens/history/hestoryscreen.dart';
import 'package:elsobkypack/screens/product/main_prod_detail_screen.dart';
import 'package:elsobkypack/screens/payment/payment.dart';
import 'package:elsobkypack/screens/payment/paymentqest.dart';
import 'package:elsobkypack/services/chekhistory.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  late Future<List<MainProd>> mainProdsFuture;
  bool isLoading = true;

  VideoPlayerController? _controller;
  List<String> mediaList = [];
  int currentIndex = 0;
  Timer? _timer;
  final CarouselController  _carouselController = CarouselController();

  int ordercountFuture = 0;
  int _selectedIndex = 0;
  Offset offset = const Offset(0, 0); // تعيين قيمة ابتدائية
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mainProdsFuture = _fetchMainProds();
    _checkUserAndFetchData();
    _initializeMediaList();
    ordercounts();
    Chekhistory().chekhistory();

    // تعيين الموضع الابتدائي في الزاوية اليمنى السفلى
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(context).size;
      setState(() {
        offset = Offset(screenSize.width - 70,
            screenSize.height - 150); // ضبط الموضع المناسب
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ordercounts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller?.play();
    }
  }

  void ordercounts() async {
    int count = await dbHelper.countOrderProducts();
    setState(() {
      ordercountFuture = count;
    });
  }

  void _initializeMediaList() async {
    mediaList = await _mainImages();
    if (mediaList.isNotEmpty) {
      _initializeMedia();
    }
  }

  Future<void> _initializeMedia() async {
    if (currentIndex >= mediaList.length) currentIndex = 0;
    String currentMedia = mediaList[currentIndex];

    _controller?.dispose();
    _controller = null;

    if (currentMedia.endsWith('.mp4')) {
      _controller = VideoPlayerController.file(File(currentMedia));
      await _controller!.initialize();
      _controller!.setLooping(false); // Disable looping
      setState(() {}); // Ensure the video player is shown
      _controller!.play();
      _controller!.addListener(_onMediaEnd);
    } else {
      _showImage();
    }
  }

  void _onMediaEnd() {
    if (_controller?.value.position == _controller?.value.duration) {
      _controller
          ?.seekTo(_controller!.value.duration); // Ensure last frame is shown
      _controller?.removeListener(_onMediaEnd);
      setState(() {
        currentIndex = (currentIndex + 1) % mediaList.length;
        _initializeMedia();
        _carouselController.nextPage(
            duration: const Duration(seconds: 2), curve: Curves.ease);
      });
    }
  }

  void _showImage() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        currentIndex = (currentIndex + 1) % mediaList.length;
        _initializeMedia();
        _carouselController.nextPage(
            duration: const Duration(seconds: 2), curve: Curves.ease);
      });
    });
  }

  void _stopMedia() {
    _controller?.pause();
    _controller?.removeListener(_onMediaEnd);
    _timer?.cancel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _checkUserAndFetchData() async {
    final checkUser = ChekUser();
    await checkUser.checkUser(context);
    setState(() {
      mainProdsFuture = _fetchMainProds();
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    _stopMedia();
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
        break;
    }
  }

  Future<List<String>> _mainImages() async {
    List<String> mainImages = await dbHelper.fetchMainImages();
    return Future.wait(mainImages.map((url) => dbHelper.getLocalPath(url)));
  }

  Future<List<MainProd>> _fetchMainProds() async {
    List<MainProd> mainProds = await dbHelper.fetchMainProds();
    for (var mainProd in mainProds) {
      mainProd.img = await dbHelper.getLocalPath(mainProd.img);
      for (var product in mainProd.products) {
        product.img = await dbHelper.getLocalPath(product.img);
      }
    }
    return mainProds;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.06),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 57, 90),
          title: const Text(
            "Elsobky Pack",
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
      ),
      drawer: SizedBox(
        width: screenSize.width * 0.6,
        child: AppDrawer(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 7.0),
                color: const Color.fromARGB(255, 255, 245, 80),
              ),
              ///////// هنا المسؤل عن حجم الشاشه اللى غلط
              SizedBox(
                height: screenSize.height * 0.25,
                width: double.infinity,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    color: const Color.fromARGB(255, 255, 57, 90),
                    child: _buildCarousel()),
              ),
              _buildNavigationRow(screenSize),
              Expanded(
                child: _buildProductList(),
              ),
            ],
          ),
          Positioned(
            left: offset.dx == 0 ? screenSize.width - 70 : offset.dx,
            top: offset.dy == 0 ? screenSize.height - 150 : offset.dy,
            child: Draggable(
              childWhenDragging: Container(), // لتجنب التكرار عند سحب الزر
              onDragEnd: (details) {
                setState(() {
                  offset = details.offset;
                });
              },
              feedback: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                child: Column(
                  children: [
                    Text(
                      '$ordercountFuture',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Icon(Icons.shopping_cart_checkout_sharp,
                        color: Colors.white),
                  ],
                ),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenSize.width * 0.8,
                            maxHeight: screenSize.height * 0.8,
                          ),
                          child: Dialog(
                            backgroundColor:
                                Colors.transparent, // جعل الخلفية شفافة
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // لون الخلفية الداخلية
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: screenSize.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 57, 90),
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                        ),
                                        child: const Text(
                                          style: TextStyle(color: Colors.white),
                                          'كاش',
                                        ),
                                        onPressed: () async {
                                          _stopMedia();
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Loading();
                                            },
                                          );

                                          final notgood = await Chekfile()
                                              .checkBeForPay(context);
                                          if (notgood && context.mounted) {
                                            Navigator.of(context)
                                                .pop(); // إغلاق Dialog التحميل
                                            setState(() {
                                              mainProdsFuture =
                                                  _fetchMainProds();
                                              _checkUserAndFetchData();
                                              _initializeMediaList();
                                              ordercounts();
                                            });
                                          } else {
                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pop(); // إغلاق Dialog التحميل
                                              Navigator.of(context)
                                                  .pop(); // إغلاق Dialog الحالي
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Payment(
                                                    setstatoforder: () {
                                                      setState(() {
                                                        ordercounts();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (mounted) {
                                                  _initializeMedia();
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      width: screenSize.width * 0.4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 57, 90),
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                        ),
                                        child: const Text(
                                          style: TextStyle(color: Colors.white),
                                          'قسط',
                                        ),
                                        onPressed: () async {
                                          _stopMedia();
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Loading();
                                            },
                                          );

                                          final notgood = await Chekfile()
                                              .checkBeForPay(context);
                                          if (notgood && context.mounted) {
                                            Navigator.of(context)
                                                .pop(); // إغلاق Dialog التحميل
                                            setState(() {
                                              mainProdsFuture =
                                                  _fetchMainProds();
                                              _checkUserAndFetchData();
                                              _initializeMediaList();
                                              ordercounts();
                                            });
                                          } else {
                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pop(); // إغلاق Dialog التحميل
                                              Navigator.of(context)
                                                  .pop(); // إغلاق Dialog الحالي
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentQest(
                                                    setstatoforder: () {
                                                      setState(() {
                                                        ordercounts();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (mounted) {
                                                  _initializeMedia();
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                backgroundColor: const Color.fromARGB(255, 255, 57, 90),
                child: Column(
                  children: [
                    Text(
                      '$ordercountFuture',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Icon(Icons.shopping_cart_checkout_sharp,
                        color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      itemCount: mediaList.length,
      carouselController: _carouselController,
      itemBuilder: (context, index, realIndex) {
        if (mediaList.isEmpty) {
          return const Center(child: Text('No media available'));
        }
        String currentMedia = mediaList[index];
        if (currentMedia.endsWith('.mp4')) {
          return _controller != null && _controller!.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  },
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        } else {
          return GestureDetector(
            onTap: () {
              _timer?.cancel();
              setState(() {
                currentIndex = index;
                _initializeMedia();
              });
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.file(
                File(currentMedia),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
      options: CarouselOptions(
        autoPlay: false,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          if (currentIndex != index) {
            _timer?.cancel();
            setState(() {
              currentIndex = index;
              _initializeMedia();
            });
          }
        },
      ),
    );
  }

  Widget _buildNavigationRow(Size screenSize) {
    return Stack(
      children: [
        Positioned(
          bottom: screenSize.height * 0.045,
          left: 0,
          right: 0,
          child: Container(
            height: screenSize.height * 0.03,
            color: const Color.fromARGB(255, 255, 57, 90),
          ),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: screenSize.height * 0.01,
                  bottom: screenSize.height * 0.01),
              height: screenSize.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildNavigationButton(
                      'images/pay.png', screenSize, _navigateToAboutPage),
                  const Spacer(flex: 1),
                  _buildNavigationButton(
                      'images/offer.png', screenSize, _navigateToHistoryPage),
                  const Spacer(flex: 1),
                  _buildNavigationButton(
                      'images/account.png', screenSize, _navigateToHomePage),
                  const Spacer(flex: 1),
                  _buildNavigationButton(
                      'images/home.png', screenSize, _navigateToHomePage),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButton(
      String imagePath, Size screenSize, VoidCallback onPressed) {
    return Container(
      width: screenSize.width * 0.15,
      height: screenSize.height * 0.1,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 245, 80),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      // child: TextButton(
      //  onPressed: onPressed,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
      //   ),
    );
  }

  void _navigateToAboutPage() {
    _stopMedia();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  void _navigateToHistoryPage() {
    _stopMedia();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  void _navigateToHomePage() {
    _stopMedia();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Widget _buildProductList() {
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder<List<MainProd>>(
      future: mainProdsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final mainProds = snapshot.data!;
          return ListView.builder(
            itemCount: mainProds.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _stopMedia();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainProdDetailScreen(
                          mainProd: mainProds[index],
                          setstatoforder: () {
                            setState(() {
                              ordercounts(); // تحديث future بعد العودة من Payment
                            });
                          }),
                    ),
                  ).then((value) {
                    _initializeMedia();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.05,
                      vertical: screenSize.height * 0.03),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildLeftBar(screenSize),
                          _buildMainImage(screenSize, mainProds[index].img),
                        ],
                      ),
                      _buildProductNames(screenSize, mainProds[index]),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildLeftBar(Size screenSize) {
    return Column(
      children: [
        SizedBox(
            height: screenSize.height * 0.05, width: screenSize.width * 0.05),
        Container(
          alignment: Alignment.bottomCenter,
          height: screenSize.height * 0.25,
          width: 20,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18)),
            color: Color.fromARGB(255, 255, 245, 80),
          ),
        ),
      ],
    );
  }

  Widget _buildMainImage(Size screenSize, String imgPath) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18)),
        color: Color.fromARGB(255, 255, 245, 80),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(18)),
        child: Image.file(
          File(imgPath),
          height: screenSize.height * 0.3,
          width: screenSize.width * 0.8,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductNames(Size screenSize, MainProd mainProd) {
    return Row(
      children: [
        Container(
          height: screenSize.height * 0.04,
          width: screenSize.width * 0.4,
          padding: EdgeInsets.only(left: screenSize.width * 0.1),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18)),
            color: Color.fromARGB(255, 255, 245, 80),
          ),
          child: Text(mainProd.showNameEN,
              style:
                  GoogleFonts.arimo(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        Container(
          height: screenSize.height * 0.04,
          width: screenSize.width * 0.4,
          padding: EdgeInsets.only(right: screenSize.width * 0.05),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(18)),
            color: Color.fromARGB(255, 255, 245, 80),
          ),
          child: Text(mainProd.showNameAR,
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontFamily: 'GE_SS_TWO_BOLD', fontSize: 16)),
        ),
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
