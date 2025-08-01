import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalCoins = 0;
  DateTime? lastClaimedTime;
  Duration remainingTime = Duration.zero;
  bool isLoading = true;
  Timer? _timer;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final claimInterval =
        kDebugMode ? Duration(seconds: 30) : Duration(hours: 12);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (lastClaimedTime != null) {
        final now = DateTime.now();
        final nextClaimTime = lastClaimedTime!.add(claimInterval);

        if (now.isBefore(nextClaimTime)) {
          setState(() {
            remainingTime = nextClaimTime.difference(now);
          });
        } else {
          setState(() {
            remainingTime = Duration.zero;
          });
        }
      }
    });
  }

  // Future<void> _fetchUserData() async {
  //   if (user == null) {
  //     setState(() => isLoading = false);
  //     return;
  //   }
  //   try {
  //     final doc =
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(user!.uid)
  //             .get();
  //     if (doc.exists) {
  //       final data = doc.data() as Map<String, dynamic>? ?? {};
  //       final coins = (data['coins'] as num?)?.toInt() ?? 0;
  //       final timestamp = data['lastClaimedTime'] as Timestamp?;
  //       setState(() {
  //         totalCoins = coins;
  //         lastClaimedTime = timestamp?.toDate();
  //         isLoading = false;
  //       });
  //     } else {
  //       // Create user document if it doesn't exist
  //       await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
  //         {'coins': 0},
  //       );
  //       setState(() => isLoading = false);
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     debugPrint('Error fetching user data: $e');
  //   }
  // }
  Future<void> _fetchUserData() async {
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final coins = (data['coins'] as num?)?.toInt() ?? 0;
        final timestamp = data['lastClaimedTime'] as Timestamp?;

        setState(() {
          totalCoins = coins;
          lastClaimedTime = timestamp?.toDate();
          isLoading = false;
        });

        _startTimer(); // ✅ START HERE, AFTER lastClaimedTime is set
      } else {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          {'coins': 0},
        );
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching user data: $e');
    }
  }

  final bool kTestingMode =
      kDebugMode; // 🔁 true for 30 sec, false for 12 hours

  Future<void> _claimDailyCoins() async {
    if (user == null || !_canClaim()) return;

    setState(() => isLoading = true);

    try {
      final now = DateTime.now();
      final newTotal = totalCoins + 2; // 2 coins every 12 hours

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'coins': newTotal, 'lastClaimedTime': now});

      setState(() {
        totalCoins = newTotal;
        lastClaimedTime = now;
        isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Success',
          '2 tokens claimed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error claiming coins: $e');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Failed',
          'Failed to claim tokens. Try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      });
    }
  }

  bool _canClaim() {
    if (lastClaimedTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastClaimedTime!);

    if (kDebugMode) {
      return difference.inSeconds >= 30; // ⏱️ 30 sec for testing
    } else {
      return difference.inHours >= 12; // 🕛 12 hours for production
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(12));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  // Widget buildClaimTimerCircle(Duration remainingTime, Duration totalTime) {
  //   final remainingSeconds = remainingTime.inSeconds;
  //   final totalSeconds = totalTime.inSeconds;
  //   final progress = remainingSeconds / totalSeconds;

  //   return TweenAnimationBuilder<double>(
  //     tween: Tween<double>(begin: progress, end: progress),
  //     duration: Duration(seconds: 1),
  //     builder: (context, value, _) {
  //       return Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           SizedBox(
  //             width: 100,
  //             height: 100,
  //             child: CircularProgressIndicator(
  //               value: value,
  //               strokeWidth: 6,
  //               backgroundColor: Colors.grey.shade300,
  //               color: Colors.orangeAccent,
  //             ),
  //           ),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.timer, color: Colors.white, size: 20),
  //               SizedBox(height: 4),
  //               Text(
  //                 _formatDuration(remainingTime),
  //                 style: TextStyle(
  //                   fontSize: 12.sp,
  //                   color: Colors.white,
  //                   fontStyle: FontStyle.italic,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Widget buildClaimTimerCircle(Duration remainingTime, Duration totalTime) {
    final remainingSeconds = remainingTime.inSeconds;
    final totalSeconds = totalTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0), // make sure it's between 0 and 1
            strokeWidth: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.orangeAccent,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.timer, color: Colors.white, size: 20),
            Text(
              'Next in',
              style: TextStyle(fontSize: 10.sp, color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              _formatDuration(remainingTime),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canClaim = _canClaim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collect Coins'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎁 Daily Reward',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Claim 2 tokens every 12 hours',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    // Button / Loader Section
                    SizedBox(
                      width: double.infinity,
                      child:
                          isLoading
                              ? const Center(
                                child: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                              : ElevatedButton(
                                onPressed: canClaim ? _claimDailyCoins : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      canClaim
                                          ? Colors.white
                                          : Colors.grey[800],
                                  foregroundColor:
                                      canClaim
                                          ? Colors.grey.shade200
                                          : Colors.white54,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  canClaim
                                      ? 'Claim Tokens: 2'
                                      : 'Come Back Later',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        canClaim
                                            ? Colors.black
                                            : Colors.grey.shade200,
                                  ),
                                ),
                              ),
                    ),

                    const SizedBox(height: 16),

                    // if (!canClaim)
                    // Text(
                    //   'Next claim in: ${_formatDuration(remainingTime)}',
                    //   style: TextStyle(
                    //     fontSize: 14.sp,
                    //     color: Colors.white,
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                    if (!canClaim)
                      Center(
                        child: buildClaimTimerCircle(
                          remainingTime,
                          kTestingMode
                              ? Duration(seconds: 30)
                              : Duration(hours: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ), // vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // rounded corners
                  ),
                ),
                child: Text(
                  'Total Tokens: $totalCoins',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
