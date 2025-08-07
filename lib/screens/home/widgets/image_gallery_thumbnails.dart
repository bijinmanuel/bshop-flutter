import 'package:bcom_app/widgets/cached_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumImageGallery extends HookWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onImageSelected;

  const PremiumImageGallery({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    final pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    final shimmerController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    final shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: shimmerController, curve: Curves.easeInOut),
    );

    useEffect(() {
      // Start animations with error handling
      try {
        animationController.repeat(reverse: true);
        shimmerController.repeat();
      } catch (e) {
        print('Animation error: $e');
      }

      return () {
        try {
          animationController.dispose();
          shimmerController.dispose();
        } catch (e) {
          print('Animation dispose error: $e');
        }
      };
    }, []);

    return
    Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Gallery Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.indigo, Colors.purple.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade200, Colors.grey.shade100],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '${images.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Image Thumbnails
            SizedBox(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 4 : 8,
                      right: index == images.length - 1 ? 4 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onImageSelected(index),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          pulseAnimation,
                          shimmerAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isSelected ? pulseAnimation.value : 1.0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutBack,
                              width: 80,
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: isSelected
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.indigo.withOpacity(0.8),
                                          Colors.purple.withOpacity(0.8),
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey.shade100,
                                          Colors.grey.shade50,
                                        ],
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.indigo.withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Colors.purple.withOpacity(0.2),
                                          blurRadius: 25,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Stack(
                                  children: [
                                    /// Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                        child: ImageDisplay(
                                          height: double.infinity,
                                          imageUrl: images[index],
                                        ),
                                      ),
                                    ),

                                    /// Overlay for non-selected items
                                    if (!isSelected)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),

                                    /// Shimmer for selected
                                    if (isSelected)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [
                                                (shimmerAnimation.value - 0.3)
                                                    .clamp(0.0, 1.0),
                                                shimmerAnimation.value.clamp(
                                                  0.0,
                                                  1.0,
                                                ),
                                                (shimmerAnimation.value + 0.3)
                                                    .clamp(0.0, 1.0),
                                              ],
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.4),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    /// Selected indicator
                                    if (isSelected)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.grey.shade100,
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.indigo,
                                            size: 14,
                                          ),
                                        ),
                                      ),

                                    /// Index number for non-selected
                                    if (!isSelected)
                                      Positioned(
                                        bottom: 6,
                                        left: 6,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    /// InkWell hover effect
                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(11),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(11),
                                        onTap: () => onImageSelected(index),
                                        splashColor: Colors.indigo.withOpacity(
                                          0.3,
                                        ),
                                        highlightColor: Colors.purple
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Indicator Dots
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final isSelected = index == selectedIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [Colors.indigo, Colors.purple],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ],
                            ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
