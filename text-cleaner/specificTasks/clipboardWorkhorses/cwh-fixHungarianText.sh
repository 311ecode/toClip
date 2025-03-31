#!/bin/bash

# Specialized function for Hungarian text cleaning
cwh-fixHungarianText() {
  local hungarianPrompt="A most következő szövegeket le kell tisztítanod, a sorrendet meg kell tartanod, de az ékezeteket ki kell tenned. A szavakat, amiket egybe kell írni, egybe írd, amit külön, azt külön. A mondat elejét nagy betűvel kell kezdened és azokat a szavakat, amiknek amúgy is nagy betűvel kell kezdődnie, mint a tulajdonnevek. A csupa nagybetűvel írt szavakat hagyd meg csupa nagybetűsnek az átdolgozás után is. Távolítsd el a felesleges szóközöket, írásjeleket és speciális karaktereket. Törekedj a helyes magyar helyesírásra, különös tekintettel az egybe- és különírás szabályaira. A központozásra különösen figyelj oda: használj megfelelő vessződet, pontot, kettőspontot, pontosvessződet ahol szükséges, és a mondatok végén mindig legyen írásjel. Az ezer alatti számokat betűvel írd, kivéve a dátumokat és a mértékegységgel ellátott számokat. A rövidítéseket egységesen kezeld: a pont nélküli rövidítéseket hagyd pont nélkül, a ponttal használtakat ponttal. Az idegen szavakat a magyar helyesírás szabályai szerint írd át, ha azok már meghonosodtak a magyar nyelvben. Az idézeteket megfelelő idézőjelbe tedd, és az idézeten belüli idézethez használj belső idézőjelet. Ha a szöveg verses vagy versszerű formátumú (tehát a normál prózához képest többszörös sortöréseket tartalmaz), akkor ezt a szerkezetet feltétlenül meg kell tartani, nem szabad folyószöveggé alakítani."
  
  local hungarianSystemPrompt="You are a helpful text formatting assistant specialized in proper Hungarian grammar and formatting. Format text according to exact specifications while preserving content, word order and meaning."
  
  # Call the generic function with Hungarian-specific parameters
  cleanClipboardText "$hungarianPrompt" "$hungarianSystemPrompt"
}
