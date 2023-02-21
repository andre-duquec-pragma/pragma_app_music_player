import 'package:flutter/material.dart';

import '../../../app_config.dart';
import '../../../blocs/bloc_responsive.dart';

String? _defaultFunction(String val) {
  return null;
}

class CustomAutoCompleteInputWidget extends StatefulWidget {
  const CustomAutoCompleteInputWidget(
      {Key? key,
      this.suggestList = const [],
      this.label = '',
      this.icondata,
      this.placeholder = '',
      required this.onEditingValueFunction,
      this.onEditingValidateFunction = _defaultFunction,
      this.initialData,
      this.keyboardType = TextInputType.text,
      this.obscureText = false})
      : super(key: key);

  final List<String> suggestList;
  final IconData? icondata;
  final String placeholder, label;
  final void Function(String val) onEditingValueFunction;
  final String? initialData;
  final String? Function(String val) onEditingValidateFunction;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  State<CustomAutoCompleteInputWidget> createState() =>
      _CustomAutoCompleteInputWidgetState();
}

class _CustomAutoCompleteInputWidgetState
    extends State<CustomAutoCompleteInputWidget> {
  late TextEditingController controller;

  // late FocusNode focusNode;

  String? initialData;
  String? errorText;

  @override
  void initState() {
    super.initState();
    initialData = widget.initialData;
  }

  void _onValidate(String val) {
    setState(() {
      errorText = widget.onEditingValidateFunction(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> autoCompleteData = widget.suggestList;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: blocCore
              .getBlocModule<ResponsiveBloc>(ResponsiveBloc.name)
              .gutterWidth),
      child: Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          } else {
            return autoCompleteData.where((word) => word
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          }
        },
        onSelected: (String selectedString) {
          controller.text = selectedString;
          _onValidate(controller.text);
          widget.onEditingValueFunction(controller.text);
          FocusScope.of(context).unfocus();
        },
        optionsViewBuilder: (context, Function(String) onSelected, options) {
          return Material(
            elevation: 4,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  // title: Text(option.toString()),
                  title: Text(controller.text),
                  // activate when been necesary subtitle: const Text("This is subtitle"),
                  onTap: () {
                    onSelected(option.toString());
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: options.length,
            ),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          this.controller = controller;
          if (initialData?.isNotEmpty == true && this.controller.text.isEmpty) {
            this.controller.text = initialData!;
          }

          final theme = Theme.of(context);

          return TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onEditingComplete: () {
              _onValidate(controller.text);
              widget.onEditingValueFunction(controller.text);
              FocusScope.of(context).unfocus();
              //onEditingComplete();
            },
            onChanged: (val) {
              _onValidate(controller.text);
              widget.onEditingValueFunction(controller.text);
            },
            decoration: InputDecoration(
              errorText: errorText,
              label: widget.label.isNotEmpty ? Text(widget.label) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.splashColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.focusColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.splashColor),
              ),
              hintText: widget.placeholder,
              prefixIcon:
                  widget.icondata != null ? Icon(widget.icondata) : null,
            ),
          );
        },
      ),
    );
  }
}
