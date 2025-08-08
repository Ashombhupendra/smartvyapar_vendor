import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';

class AnimatedMapIconMinimised extends StatefulWidget {
  const AnimatedMapIconMinimised({super.key});

  @override
  State<AnimatedMapIconMinimised> createState() => _AnimatedMapIconMinimisedState();
}

class _AnimatedMapIconMinimisedState extends State<AnimatedMapIconMinimised> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack( alignment: AlignmentDirectional.center, children: [
        Lottie.asset(Images.mapIconMinimised , repeat: false, height: Dimensions.pickMapIconSize,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(
                const ['Red circle Outlines', '**'],
                value: Theme.of(context).colorScheme.primary,
              ),
              ValueDelegate.color(
                const ['Shape Layer 1', '**'],
                value: Theme.of(context).colorScheme.primary,
              ),
              ValueDelegate.color(
                const ['shadow Outlines', '**'],
                value: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
        ),

        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 0.1),
          duration: const Duration(milliseconds: 400),
          builder: (BuildContext context, double value, Widget? child) {
            return Padding(
              padding:  const EdgeInsets.only(top: Dimensions.pickMapIconSize * 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min,
                children: List.generate(9, (index){
                  return  Icon(Icons.circle, size: index == 8 ? Dimensions.pickMapIconSize * 0.06 : Dimensions.pickMapIconSize * 0.03,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: value),
                  );
                }),
              ),
            );
          },
        )
      ],),
    );
  }
}