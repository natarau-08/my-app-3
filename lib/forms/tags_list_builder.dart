

import 'package:flutter/material.dart';

import '../controls/centered_widgets.dart';
import '../floor/tables/tag.dart';
import '../utils.dart';

class TagsListBuilder extends StatelessWidget{
  final Stream<List<Tag>> stream;
  final void Function(BuildContext context, DismissDirection dir, Tag tag) onDismissed;
  final void Function(BuildContext context, Tag tag) onItemTap;
  final Future<bool> Function(BuildContext context, DismissDirection dir, Tag tag) onConfirmDismiss;
  final DismissDirection dismissDirection;

  const TagsListBuilder({
    super.key,
    required this.stream,
    required this.onDismissed,
    required this.onItemTap,
    required this.onConfirmDismiss,
    required this.dismissDirection
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const SimpleProgressIndicator('Loading tags...');
        } else if(snapshot.hasError){
          return SimpleErrorIndicator('Error loading tags: ${snapshot.error}');
        } else if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const NoDataAvailableCenteredWidget();
        }else{

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
              final tag = snapshot.data![index];

              final cs = Theme.of(context).colorScheme;
              final Color? color = tag.color;

              return Dismissible(
                key: Key(tag.id.toString()),
                
                direction: dismissDirection,

                background: Container(
                  color: cs.error,
                  child: Icon(
                    Icons.delete,
                    color: cs.onError,
                  )
                ),
                
                secondaryBackground: Container(
                  color: Colors.green,
                  child: Icon(
                    Icons.restore_from_trash,
                    color: cs.onPrimary,
                  ),
                ),

                confirmDismiss: (d) => onConfirmDismiss(context, d, tag),

                onDismissed: (d) => onDismissed(context, d, tag),

                child: ListTile(
                  title: Text(tag.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(tag.description != null) Text(tag.description!),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          Utils.formatDateTimeLong(tag.added),
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black45
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.circle, color: color ?? Colors.transparent,),
                  splashColor: color,

                  onTap: () => onItemTap(context, tag),
                ),
              );
            },

            separatorBuilder: (context, index) {
              return const Divider(height: 1,);
            },
          );
        }
      }
    );
  }
}