'use-strict';

import React, { Component } from 'react';
import { NavigationActions } from 'react-navigation';
import firebase from 'firebase';
import { LoginForm } from './LoginForm';

import {
  View,
  ListView,
  Text,
  TouchableHighlight, 
  Button,
  Icon,
  Picker, StyleSheet,
  AsyncStorage
} from 'react-native';
export default class DestinationsList extends Component {
  constructor(props) {
    super(props);
    this.itemsRef = firebase.database().ref('/touristAttractions');
    var dataSource = new ListView.DataSource({rowHasChanged:(r1,r2) => r1.id != r2.id});    
    this.state = {  
      loggedIn : false,
      dataSource: dataSource,
      countries: global.attractionsArray.map((value) => value.country).sort().filter(function(item, pos, ary) {
        return !pos || item != ary[pos - 1];
      }),
      country: global.attractionsArray[0].country,
      userRole: null,
    }
    console.disableYellowBox = true;
    this.listenForItems(this.itemsRef);
    
  
  }
  
    setUserRatings() {
      firebase.database().ref('/users/'+this.state.userKey+'/ratings').once('value', (snap) => {
          snap.forEach((childSnap) => {
          setRatingForAttr(childSnap.val().attrId, childSnap.val().rating);
          // if(childSnap.val().attrId == this.state.id) {
          //     this.setState({ratingAverage: childSnap.val().rating});                     
          // }
          });
      });        

  }
  setRatingForAttr(id, rating) {
    for(var i = 0; i<global.attractionsArray.length; i++) {
      if(global.attractionsArray[i].id == id) {
        console.warn(id);
        global.attractionsArray[i].rating = rating;
      }
    }
  }
  calculateRatingAverage() {
    global.items = global.attractionsArray;
    for(var i=0; i<global.items.length; i++) {
      global.items[i].ratingAverage = 0;
    }
  
    firebase.database().ref('/users').once('value', (snap) => {
      snap.forEach((childSnap) => {
        childSnap.child('ratings').forEach((rating) => {
           this.addRating(parseInt(rating.val().rating), rating.val().attrId);
        }
      );
      });
     });
  }

  addRating(rating, attractionId) {
       
    for(var i=0; i<global.items.length; i++ ) {
      if(global.items[i].id === attractionId) {
        
            if (global.items[i].ratingAverage != 0) {
              var add = (global.items[i].ratingAverage + rating)/2;
              global.items[i].ratingAverage = add;
              
          } else {
              global.items[i].ratingAverage = rating;
          }
          this.itemsRef.child(attractionId).update({ratingAverage: global.items[i].ratingAverage})
      }
    }
  }

  listenForItems(itemsRef) {
    itemsRef.on('value', (snap) => {
      
            // get children as an array
            var items = [];
            snap.forEach((child) => {
              items.push({
                city: child.val().city,
                country: child.val().country,
                name: child.val().name,
                ratingAverage: child.val().ratingAverage,
                rating: 0,
                id: child.key
              });
            });
            global.attractionsArray = items;
            this.setUserRatings();
            
            this.setState({
              dataSource: this.state.dataSource.cloneWithRows(items),
              countries: items.map((value) => value.country).sort().filter(function(item, pos, ary) {
                return !pos || item != ary[pos - 1]
              }),
              country: items[0].country
            });
            
      
          });
          
  }

  async getFromAsyncStorage() {
    try {
      const value = await AsyncStorage.getItem("user_role");
      if (value !== null){
        this.setState({userRole : value});

      }
    } catch (error) {
      console.warn("error getting stuff");
    }

    
  }

  componentWillMount() {
  
      this.getFromAsyncStorage();
      
     
  }
  saveArray() {
    AsyncStorage.setItem("attractionsArray", JSON.stringify(global.attractionsArray));
  }
  edit(destination){
      this.props.navigation.navigate("Destination", { dest: destination, userRole: this.state.userRole,
        onGoBack: () => this.update()
      });
    
  }
  update() {
    this.calculateRatingAverage();
    var newDataSource = new ListView.DataSource({rowHasChanged:(r1,r2) => r1.id != r2.id});
    var newArray = global.attractionsArray;
    var newCountries = global.attractionsArray.map((value) => value.country).sort().filter(function(item, pos, ary) {
      return !pos || item != ary[pos - 1];
    });
    this.setState({
      dataSource: newDataSource.cloneWithRows(newArray),
      countries: newCountries
    });
  }
  renderRow(destination){
        return(
            <TouchableHighlight onPress={() => this.edit(destination)}>
            <View style={styles.list}>
                <Text style={styles.listElement}>{destination.name}</Text>
            </View>
            </TouchableHighlight>
      );
  }
  static navigationOptions = ({ navigation}) => ({
    title: 'Destinations List',
    headerTitleStyle :{textAlign: 'center',alignSelf:'center'},
    headerStyle:{
        backgroundColor:'white',
    },
    headerLeft:  <Button title = "Statistics" onPress={ () => { navigation.navigate("Statistics") } }  /> 
  });

  add(){
    this.props.navigation.navigate("Destination" , {dest: {}, userRole: this.state.userRole, onGoBack: () => this.update()
    });
  }
  updateCountry = (country) => {
    var filteredArray = [];
    for (var i = 0; i < attractionsArray.length; i++) {
      if (global.attractionsArray[i].country === country) {
          filteredArray.push(global.attractionsArray[i]);
      }
    } 
    var newDataSource = new ListView.DataSource({rowHasChanged:(r1,r2) => r1.id != r2.id});      
    this.setState({ country: country,
    dataSource: newDataSource.cloneWithRows(filteredArray)
    });
  }

  checkLogIn() {
    var logged;
    firebase.auth().onAuthStateChanged(function(user) {
        if (user) {
            logged = true;
        } else {
            logged = false;
        }
      });
      this.setState({loggedIn : logged});
    }

 

  render() {
    if(this.state.userRole == "ADMIN") {
      return(
        <View style={{flex: 1}}>
               <ListView dataSource={this.state.dataSource} renderRow={this.renderRow.bind(this)}/>
               <Picker selectedValue = {this.state.country} onValueChange = {this.updateCountry}>
                      {this.state.countries.map((value) => <Picker.Item label={value} value={value}/>)}
                   </Picker>
               <Button title="Add" onPress={()=>this.add()}/>  
               <Button title="Save" onPress={()=>this.saveArray()}/>  
             </View> 
      );
    } else {
      return(
        <View style={{flex: 1}}>
               <ListView dataSource={this.state.dataSource} renderRow={this.renderRow.bind(this)}/>
               <Picker selectedValue = {this.state.country} onValueChange = {this.updateCountry}>
                      {this.state.countries.map((value) => <Picker.Item label={value} value={value}/>)}
                   </Picker>
             </View> 
      );
    }
   
  }
  
};

const styles = StyleSheet.create({
  container: {
     paddingTop: 23,
     borderRadius: 4,
     borderWidth: 0.5,
     borderColor: '#d6d7da',
  },
  list: {
  //  paddingTop: 20,
  //  paddingBottom: 20,
  },
  listElement: {
    borderWidth: 0.5,
    fontSize: 19,
    paddingTop: 10,
    paddingBottom: 10,   
    paddingLeft: 5, 
    fontWeight: 'bold',
  }
})



