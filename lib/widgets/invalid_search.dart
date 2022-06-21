import 'package:flutter/material.dart';

class InvalidSearch extends StatelessWidget {
  final void Function()? onCleanFilterTap;

  const InvalidSearch({
    Key? key,
    this.onCleanFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.search_off_outlined,
          size: 72,
          color: Colors.blue,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.center,
          width: 250,
          child: Text(
            "Não foram encontrados resultados para a sua pesquisa!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                .copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: onCleanFilterTap,
            style: TextButton.styleFrom(primary: Colors.grey),
            child: Text(
              "Limpar filtro",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                  .copyWith(color: Colors.blue),
            ))
      ],
    );
  }
}
