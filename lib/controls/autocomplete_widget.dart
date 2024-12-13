
import 'dart:async';

import 'package:flutter/material.dart';

class AutocompleteWidget<T extends Object> extends StatelessWidget {
  final FutureOr<Iterable<T>> options;
  final String Function(T item) displayStringForOption;
  final Widget Function(BuildContext context, T item)? optionBuilder;

  final void Function(T item)? onSelected;
  final Widget Function(T element, int index)? itemViewBuilder;
  final void Function(TextEditingController tec)? onFieldBuilding;
  
  const AutocompleteWidget({
    super.key,
    required this.options,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.itemViewBuilder,
    this.onSelected,
    this.onFieldBuilding,
    this.optionBuilder
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<T>(
        onSelected: onSelected,
        // displayStringForOption: displayStringForOption,
        optionsBuilder: (tev) async {
          // if(tev.text.isEmpty) return Iterable<T>.empty();

          Iterable<T> optionsIterable;
          if(options is Future<Iterable<T>>) {
            optionsIterable = await options;
          }
          else if(options is Iterable<T>){
            optionsIterable = options as Iterable<T>;
          }else{
            if(context.mounted) {
              ScaffoldMessenger
                .of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text('Error: Autocomplete options future did not return the expected iterable: $options'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  )
                );
            }

            return Iterable<T>.empty();
          }
      
          final String text = tev.text.toLowerCase();
          return optionsIterable.where((o) => displayStringForOption(o).toLowerCase().contains(text));
        },
      
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: constraints.maxWidth
                ),
                child: ListView.builder(
                  itemCount: options.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final T option = options.elementAt(index);
                    
                    if(itemViewBuilder != null){
                      return itemViewBuilder!(option, index);
                    }

                    if(optionBuilder != null) return optionBuilder!(context, option);

                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(displayStringForOption(option)),
                      )
                    );
                  },
                ),
              ),
            ),
          );
        },

        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          onFieldBuilding?.call(textEditingController);
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (_) => onFieldSubmitted,
            decoration: const InputDecoration(hintText: '---'),
          );
        },
      ),
    );
  }
}