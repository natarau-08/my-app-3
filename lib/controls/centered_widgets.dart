
import 'package:flutter/material.dart';

class SimpleVerticalCenteredWidget extends StatelessWidget {
  final List<Widget> children;
  const SimpleVerticalCenteredWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }
}

class SimpleCenteredWidget extends StatelessWidget {
  final Widget child;
  final String text;
  const SimpleCenteredWidget({super.key, required this.text, required this.child});

  @override
  Widget build(BuildContext context) {
    return SimpleVerticalCenteredWidget(
      children: [
        child,
        Text(text)
      ]
    );
  }
}

class SimpleProgressIndicator extends StatelessWidget {
  final String text;
  const SimpleProgressIndicator(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleCenteredWidget(
      text: text,
      child: const CircularProgressIndicator()
    );
  }

  static Widget? handleSnapshotForLoadingOrError(AsyncSnapshot<Object> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){
      return const SimpleProgressIndicator('Loading data...');
    } else if(snapshot.hasError){
      return SimpleErrorIndicator('Loading data error: ${snapshot.error}');
    } else {
      return null;
    }
  }
}

class SimpleErrorIndicator extends StatelessWidget {
  final String text;

  const SimpleErrorIndicator(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return SimpleCenteredWidget(
      text: text,
      child: Icon(
        Icons.error,
        color: Theme.of(context).colorScheme.error,
        size: 40,
      ),
    );
  }
}

class SimpleInfoIndicator extends StatelessWidget {
  final String text;

  const SimpleInfoIndicator(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleCenteredWidget(
      text: text,
      child: Icon(
        Icons.info,
        color: Theme.of(context).colorScheme.primary,
        size: 40,
      ),
    );
  }
}

class NoDataAvailableCenteredWidget extends StatelessWidget {
  const NoDataAvailableCenteredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleVerticalCenteredWidget(
      children: [
        Text('No data available')
      ]
    );
  }
}

class NotImplementedWidget extends StatelessWidget {
  const NotImplementedWidget({super.key});

  @override
  Widget build(Object context) {
    return SimpleInfoIndicator('This page is not implemented yet.');
  }
  
}