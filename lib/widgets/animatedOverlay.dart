import 'dart:async';
import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({
    this.parentOverlayReference,
    this.title,
    this.content,
    this.actions,
  });

  final OverlayEntry parentOverlayReference;
  final Widget title, content;
  final List<Widget> actions;

  @override
  OverlayWidgetState createState() => new OverlayWidgetState();
}

class OverlayWidgetState extends State<OverlayWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 450),
    );

    opacityAnimation = new Tween<double>(begin: 0.0, end: 0.4).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    scaleAnimation = new CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void didUpdateWidget(OverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller.reset();
    controller.forward();
  }

  Future<void> startDisposal() async {
    await controller.reverse();
    widget.parentOverlayReference.remove();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: new ScaleTransition(
        scale: scaleAnimation,
        child: new Padding(
          padding: MediaQuery.of(context).viewInsets +
              const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 24.0,
              ),
          child: new MediaQuery.removeViewInsets(
            removeLeft: true,
            removeTop: true,
            removeRight: true,
            removeBottom: true,
            context: context,
            child: new Center(
              child: new Container(
                decoration: new ShapeDecoration(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
                child: new ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 280.0),
                  child: new IntrinsicWidth(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.fromLTRB(
                            24.0,
                            24.0,
                            24.0,
                            0.0,
                          ),
                          child: new DefaultTextStyle(
                            style: Theme.of(context).textTheme.title,
                            child: new Semantics(
                              child: widget.title,
                              namesRoute: true,
                              container: true,
                            ),
                          ),
                        ),
                        new Flexible(
                          child: new Padding(
                            padding: const EdgeInsets.fromLTRB(
                              24.0,
                              12.0,
                              24.0,
                              0.0,
                            ),
                            child: new DefaultTextStyle(
                              style: Theme.of(context).textTheme.subhead,
                              child: widget.content,
                            ),
                          ),
                        ),
                        new ButtonTheme.bar(
                          child: new ButtonBar(
                            children: <Widget>[
                              new FlatButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  startDisposal();
                                },
                              ),
                            ]..insertAll(0, widget.actions),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedOverlay {
  const AnimatedOverlay({
    this.title,
    this.content,
    this.actions,
  });

  final Widget title;
  final Widget content;
  final List<Widget> actions;

  OverlayEntry call() {
    OverlayEntry modal;

    modal = new OverlayEntry(
      builder: (BuildContext context) {
        return OverlayWidget(
          parentOverlayReference: modal,
          title: title,
          content: content,
          actions: actions,
        );
      },
    );

    return modal;
  }
}
