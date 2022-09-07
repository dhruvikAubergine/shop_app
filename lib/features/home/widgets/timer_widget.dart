import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/models/product.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration.zero;
  Timer? timer;
  DateTime dateTime = DateTime.now();

  void startTimer() {
    final second =
        (widget.product.duration ?? (dateTime.add(const Duration(seconds: 60))))
            .difference(
              dateTime,
            )
            .inSeconds;
    log(second.toString());
    duration = Duration(seconds: second);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      addTime();
      log(duration.inSeconds.toString());
    });
  }

  void addTime() {
    final secound = duration.inSeconds - 1;

    if (secound < 0) {
      widget.product.checkSalesAvailability = false;
      cancelTimer();
    }
    duration = Duration(seconds: secound);

    if (mounted) {
      setState(() {});
    }
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  void cancelTimer() {
    if (timer != null && (timer?.isActive ?? false)) {
      timer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.product.duration == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final time = DateTime.now().add(const Duration(seconds: 60));
        Provider.of<ProductProvider>(context, listen: false).setDurationForItem(
          widget.product.id!,
          time,
        );
      });
    }
    if (widget.product.checkSalesAvailability) {
      startTimer();
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.product.checkSalesAvailability
        ? Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    '20% Off',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Text(
                    'Hurry up! sales ends in',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      timerCard(
                        time: twoDigits(duration.inHours.remainder(60)),
                        header: 'hrs',
                      ),
                      const SizedBox(width: 10),
                      timerCard(
                        time: twoDigits(duration.inMinutes.remainder(60)),
                        header: 'mins',
                      ),
                      const SizedBox(width: 10),
                      timerCard(
                        time: twoDigits(duration.inSeconds.remainder(60)),
                        header: 'secs',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget timerCard({required String time, required String header}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          header,
          style: const TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
