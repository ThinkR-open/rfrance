# rfrance

Le package contient la fonction `snapshot` qui permet de snapshoter un article de blog. 

```R
snapshot( "https://thinkr.fr/de-retour-de-user2017/" )
```

`snapshot` 
  - utilise `webshot::webshot` pour faire un snapshot du post
  - recupere de l'information en parsant le html du post

## Comment soumettre un article

Il y a deux choses dans `rfrance`: 
 - un site construit avec hugo et blogdown
 - un package (avec la fonction snapshot)

Pour soumettre un article, vous pouvez ouvrir une issue en donnant son lien. 

Ou préparer un pull request, c'est un peu plus de travail pour vous, mais un peu moins pour nous. Du coup c'est plus rapide. 
Pour préparer le pr, il vous faut: 

 - forker le repo sous votre nom d'utilisateur github (par exemple "moi")
 - cloner votre fork
 
```
$ git clone https://github.com/{moi}/rfrance
$ cd rfrance
```

A ce moment là, vous pouvez installer le package R via `devtools::install('.')` mais le plus simple est: 

```R
install_github("ThinkR-open/rfrance")
library(rfrance)
```

Ensuite, on utilise la fonction `rfrance::snapshot` pour generer un fichier `.md` et un 
fichier `.png`. Par exemple: 

```
snapshot( "https://thinkr.fr/de-retour-de-user2017/" )
```

ce qui crée:
 - un fichier `.md` dans `content/post`
 - un fichier `.png` dans `static/images`
 
Ensuite, vous pouvez voir ce que ça donne avec `blogdown::serve_site()`

Puis commiter et pusher les modifications (en principe juste sur ces 2 fichiers)

```
$ git commit -a -m "+ un article sur la pluie et le beau temps"
$ git push
```

Dernière etape, soumettre la pull request sur github. 

