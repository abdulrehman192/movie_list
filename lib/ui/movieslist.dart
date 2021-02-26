import 'dart:convert';

import 'package:flutter/material.dart';

class moviehome extends StatefulWidget {
  @override
  _moviehomeState createState() => _moviehomeState();
}

class _moviehomeState extends State<moviehome>
{
  List<dynamic> Film;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: Container(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/film.json'),
          builder: (context,snapshot)
          {
            if(snapshot.hasData) {
              Film = json.decode(snapshot.data.toString());
              return ListView.builder
                (
                  itemCount: Film.length == null ? 0 : Film.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack
                      (
                      children: <Widget>[
                        CustomCard(context, index),
                        Positioned
                          (
                            top: 6,
                            child: MovieImage(Film[index]['Images'][0]))
                      ],
                    );
                  }
              );
            }
            else
              {
                return CircularProgressIndicator();
              }
          },
        ),
      ),
    );
  }

  Widget CustomCard(BuildContext context, int index)
  {
      String rating = 'Rating : N/A';
      if(Film[index]['imdbRating'] != 'N/A')
      {
        rating = 'Rating : '+Film[index]['imdbRating'];
      }
      return InkWell
      (
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: Card(
            margin: EdgeInsets.only(top:8,left: 54),
            child: Padding(
              padding: EdgeInsets.only(left: 54,top: 8,bottom: 8,right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(child: Text(Film[index]['Title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                      Text(rating,style: TextStyle(fontSize: 10))
                    ],
                  ),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Released : ${Film[index]['Released']}',style: TextStyle(fontSize: 10),),
                      Text(Film[index]['Runtime'],style: TextStyle(fontSize: 10),),
                      Text(Film[index]['Rated'],style: TextStyle(fontSize: 10),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () =>
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
          MovieDetails(Movie: Film,index: index)
          ))
        },
      );
  }

 Widget MovieImage(String image_url)
 {
   return Container(
     height: 94,
     width: 94,
     decoration: BoxDecoration(
       image: DecorationImage(
         image: NetworkImage(image_url ??  'https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png'),
         fit: BoxFit.cover
       )
     ),
   );
 }
}

class MovieDetails extends StatefulWidget
{
  final List<dynamic> Movie;
  final int index;
  const MovieDetails({Key key, this.Movie,this.index}) : super(key: key);
  @override
  _MovieDetailsState createState() => _MovieDetailsState(this.Movie,this.index);
}

class _MovieDetailsState extends State<MovieDetails>
{
  final List<dynamic> Movie;
  final int index;

  _MovieDetailsState(this.Movie, this.index);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Movie[index]['Title']),
        ),
      body: Container(
          child: ListView(
            children: <Widget>[

                  movieDetailThumbnail(thumbnail: Movie[index]['Images'][0]),
                  movieposterwithheader(Movie: Movie, index: index,),
                  moviecastdetail(Movie: Movie, index: index,),
                  horizontal_line(),
                  moreposterCards(Poster: Movie[index]['Images'])
            ],

          )
      ),
    );
  }

}
class moreposterCards extends StatelessWidget {
  final List<dynamic> Poster;

  const moreposterCards({Key key, this.Poster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Poster.length < 0) {
      return CircularProgressIndicator();
    }
    else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Text("More Movie Posters".toUpperCase(),
              style: TextStyle(fontSize: 14, color: Colors.black26),),
            Container(
              height: 180,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Poster == null ? 0 : Poster.length,
                  separatorBuilder: (context, index) => SizedBox(width: 10,)
                  , itemBuilder: (context, index) =>
                  ClipRRect(

                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(

                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 4,
                      height: 160,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(Poster[index]),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  )
              ),
            ),
          ]
      );
    }
  }
}


class horizontal_line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }
}


class movieDetailThumbnail extends StatelessWidget {

  final String thumbnail;

  const movieDetailThumbnail({Key key, this.thumbnail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                  image : DecorationImage(
                      image: NetworkImage(thumbnail ?? 'https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png'),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Icon(Icons.play_circle_outline,size: 100,color: Colors.white,)
          ],
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0x00f5f5f5),Color(0xfff5f5f5)],begin: Alignment.topCenter,end: Alignment.bottomCenter),

          ),

        )
      ],
    );
  }
}

class movieposterwithheader extends StatelessWidget
{
  final  List<dynamic> Movie;
  final int index;

  const movieposterwithheader({Key key, this.Movie,this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          moviePoster(poster: Movie[index]['Images'][0],),
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: movieheader(Movie: Movie,index: index,)
          )
        ],
      ),
    );
  }
}
class movieheader extends StatelessWidget
{
  final List<dynamic> Movie;
  final int index;

  const movieheader({Key key, this.Movie, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left : 8.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${Movie[index]['Year']} . ${Movie[index]['Genre']}".toUpperCase(),
            style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.w400),),
          Text(Movie[index]['Title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
          Text.rich(TextSpan(style: TextStyle(
              fontSize: 15,fontWeight: FontWeight.w300
          ),
              children: <TextSpan>[
                TextSpan(
                  text: Movie[index]['Plot'],
                ),
                TextSpan(
                    text: 'More...',
                    style: TextStyle(color: Colors.indigoAccent)
                )
              ]
          ))
        ],
      ),
    );
  }
}

class moviecastdetail extends StatelessWidget {
  final List<dynamic> Movie;
  final int index;

  const moviecastdetail({Key key, this.Movie, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          moviefield(field: "Cast",value: Movie[index]['Actors']),
          moviefield(field: "Director",value: Movie[index]['Director']),
          moviefield(field: "Writer",value: Movie[index]['Writer']),
          moviefield(field: "Awards",value: Movie[index]['Awards']),
          moviefield(field: "Languages",value: Movie[index]['Language']),
        ],
      ),
    );
  }
}

class moviefield extends StatelessWidget
{
  final String field;
  final String value;

  const moviefield({Key key, this.field, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("${field} : ",style: TextStyle(color: Colors.black38,fontSize: 12,fontWeight: FontWeight.w300),),
        Expanded(child: Text(value,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w300),))
      ],
    );
  }
}

class moviePoster extends StatelessWidget {
  final poster;

  const moviePoster({Key key, this.poster}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(

        child : ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(

            width: MediaQuery.of(context).size.width / 4,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(poster),
                    fit: BoxFit.cover
                )
            ),
          ),
        ));
  }
}