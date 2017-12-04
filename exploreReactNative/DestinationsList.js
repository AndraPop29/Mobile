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
  
    var dataSource = new ListView.DataSource({rowHasChanged:(r1,r2) => r1.id != r2.id});
    this.state = {  
      dataSource: dataSource.cloneWithRows(global.attractionsArray),
      countries: global.attractionsArray.map((value) => value.country).sort().filter(function(item, pos, ary) {
        return !pos || item != ary[pos - 1];
      }),
      country: global.attractionsArray[0].country
    }
  
  }
  
  componentWillMount() {
      AsyncStorage.getItem("attractionsArray").then((value) => {
          if(value != "null") {
            global.attractionsArray = JSON.parse(value);
            this.update();
        }
      })
  }
  saveArray() {
    AsyncStorage.setItem("attractionsArray", JSON.stringify(global.attractionsArray));
  }
  edit(destination){
      this.props.navigation.navigate("Destination", { dest: destination,
        onGoBack: () => this.update()
      });
    
  }
  update() {
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
    this.props.navigation.navigate("Destination" , {dest: {}, onGoBack: () => this.update()
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

  render() {
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

