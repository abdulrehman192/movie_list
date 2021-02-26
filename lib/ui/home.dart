
import 'dart:convert';

import 'package:flutter/material.dart';

class movie_list extends StatefulWidget {
  @override
  _movie_listState createState() => _movie_listState();
}

class _movie_listState extends State<movie_list>
{
  List<dynamic> Film;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.blueGrey.shade500,
      ),

      body: Container(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/film.json'),
          builder: (context,snapshot)
          {
            Film = json.decode(snapshot.data.toString());
            return ListView.builder
              (
              itemCount: Film.length == null ? 0 : Film.length ,
                itemBuilder: (BuildContext context,int index)
                {
                  return Stack(
                    children: <Widget>[
                      CustomCard(context,index),
                      Positioned
                      (
                      top : 8,
                      child : movieImage(Film[index]['Images'][0])
                      )
                    ],
                  );
                }
            );
          },
        ),
      ),
    );
  }

  Widget CustomCard(BuildContext context,int index)
  {
    var rating = 'Rating : N/A';
    if(Film[index]['imdbRating'] != 'N/A')
    {
      rating = 'Rating : ${Film[index]['imdbRating']}/10';
    }
    return InkWell(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        child: Card(
          margin: EdgeInsets.only(left: 45,top: 8),
          child: Padding(
            padding: const EdgeInsets.only(top: 8,left: 54,bottom: 8,right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row
                  (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(child: Text(Film[index]['Title'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)),
                      Text(rating,style: TextStyle(color: Colors.black87,fontSize: 13),)
                    ],
                  ),
                Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Released : ${Film[index]['Released']}',style: TextStyle(fontSize: 10),),
                    Text(Film[index]['Runtime'],style: TextStyle(fontSize: 10) ,),
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
            MovieDetails(movieName: Film[index]['Title'],Movie: Film,index: index,)

        ))
      },
    );
  }
  Widget movieImage(String imageurl)
  {
    return Container(
      height: 94,
      width: 94,
      decoration: BoxDecoration(

        image: DecorationImage(
          image: NetworkImage(imageurl?? 'https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png'),
          fit: BoxFit.cover
        )
      ),
    );
  }
}

class MovieDetails extends StatefulWidget {
  final String movieName;
  final int index;
  final List<dynamic> Movie;

  const MovieDetails({Key key, this.movieName, this.index, this.Movie}) : super(key: key);
  @override
  _MovieDetailsState createState() => _MovieDetailsState(movieName: this.movieName,index: this.index,Movie: this.Movie);
}

class _MovieDetailsState extends State<MovieDetails> {
  final String movieName;
  final int index;
  final List<dynamic> Movie;

  _MovieDetailsState({this.movieName, this.index, this.Movie});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(Movie[index]['Title']),
        backgroundColor: Colors.blueGrey.shade500,
      ),
    );
  }
}

