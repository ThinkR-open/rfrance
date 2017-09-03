# rfrance

Le package contient la fonction `snapshot` qui permet de snapshoter un article de blog. 

```R
snapshot( "https://thinkr.fr/de-retour-de-user2017/" )
```

`snapshot` 
  - utilise `webshot::webshot` pour faire un snapshot du post
  - recupere de l'information en parsant le html du post

## Comment soumettre un article

Dans un premier temps, il faut cloner le repo. On utilise un sous module pour 
le theme, alors il faut faire un clone recursif. 

```
$ git clone --recursive https://github.com/ThinkR-open/rfrance
$ cd rfrance
```

Ensuite, il faut installer le code en tant que package R, par exemple:

```R
devtools::install(".")
```

Et enfin, on utilise la fonction `snapshot` à qui on donne au moins l'url

```
snapshot( "https://thinkr.fr/de-retour-de-user2017/" )
```

`snapshot` crée:
 - un fichier `.md` dans `content/post`
 - un fichier `.png` dans `static/images`
 
Et après, on reconstruit le site avec `blogdown::serve_site()`

Plus qu'à soumettre les deux fichiers ajoutés en tant que pull request. 
