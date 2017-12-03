'use-strict';

import React from 'react';

import {
  StyleSheet,
  Text,
  View,
  Navigator,
  TextInput,
  Button,
  ListView,
  ScrollView,
  TouchableOpacity,
  Linking,
  Picker,
  Alert, 
  FormInput,
  FormLabel,
} from 'react-native';
import PropTypes from 'prop-types';
import { Pie } from 'react-native-pathjs-charts';
var ratingChanged = false;                      
export default class EditDestination extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            id:0,
            name: "",
            city:"",
            country:"",
            ratingSum: 0,
            ratingAverage: 0,
            noOfRatings: 0
        };
        
        if (this.props.navigation.state.params.dest.id !== undefined) {
            var toEdit = this.props.navigation.state.params.dest;
            this.state.id = toEdit.id;
            this.state.name = toEdit.name;
            this.state.city = toEdit.city;
            this.state.country = toEdit.country;
            this.state.ratingSum = toEdit.ratingSum;
            this.state.ratingAverage = toEdit.ratingAverage;            
            this.state.noOfRatings = toEdit.noOfRatings;
        }
    }

    

    static navigationOptions = ({ navigation}) => ({
        headerTitleStyle :{textAlign: 'center',alignSelf:'center'},
        headerStyle:{
            backgroundColor:'white',
        },
        headerLeft:  <Button title = "Back" onPress={ () => { navigation.goBack() } }  /> 
      });

    save() {
        if (this.state.id === 0){
            if(this.state.name === "" || this.state.country ==="" || this.state.city ==="" || ratingChanged ===false) {
                Alert.alert(
                    'None of the fields can be empty'
                 )
            } else {
                var attr = {
                    id: global.count,
                    name: this.state.name,
                    city: this.state.city,
                    country: this.state.country,
                    ratingSum: parseInt(this.state.ratingAverage),
                    ratingAverage: parseInt(this.state.ratingAverage),
                    noOfRatings: 1
                };
                global.count = global.count + 1;
                global.attractionsArray.push(attr); 
                this.props.navigation.state.params.onGoBack();
                this.props.navigation.goBack(); 
            }          
        }
        else{
            var element = this.state;
            for (var i = 0; i < global.attractionsArray.length; i++) {
                if (global.attractionsArray[i].id === element.id) {
                    if(ratingChanged ===true) {
                        var noOfRatings = element.noOfRatings + 1;
                        element.ratingSum = global.attractionsArray[i].ratingSum + parseInt(this.state.ratingAverage);
                        element.noOfRatings = noOfRatings;
                        element.ratingAverage = element.ratingSum / noOfRatings;
                    }
                    global.attractionsArray[i] = element;
                    
                }
            }
            this.props.navigation.state.params.onGoBack();
            this.props.navigation.goBack();
        }
   
    }
    delete() {
        if (this.state.id === 0){        
            Alert.alert(
                'The location was not added, therefore cannot be deleted'
             )
        }
        else{
            var element = this.state;
            for (var i = 0; i < attractionsArray.length; i++) {
                if (global.attractionsArray[i].id === element.id) {
                    global.attractionsArray.splice(i, 1);
                }
            }
            this.props.navigation.state.params.onGoBack();
            this.props.navigation.goBack();
        }
    }
    handleRatingChange(rating) {
        this.setState({ratingAverage: rating});
        ratingChanged = true;
      }

    render() {
        let options = {
            margin: {
              top: 20,
              left: 20,
              right: 20,
              bottom: 20
            },
            width: 350,
            height: 350,
            color: '#2980B9',
            r: 50,
            R: 150,
            legendPosition: 'topLeft',
            animate: {
              type: 'oneByOne',
              duration: 200,
              fillTransition: 3
            },
            label: {
              fontFamily: 'Arial',
              fontSize: 8,
              fontWeight: true,
              color: '#ECF0F1'
            }
          }
         
        return (
            <View style = {styles.container}>
            <TextInput style = {styles.input}
               underlineColorAndroid = "transparent"
               placeholder = "Name"
               placeholderTextColor = "#9a73ef"
               autoCapitalize = "none"
               onChangeText = {(name)=>this.setState({name})}
               value={this.state.name.toString()}/>


            <TextInput style = {styles.input}
               underlineColorAndroid = "transparent"
               placeholder = "City"
               placeholderTextColor = "#9a73ef"
               autoCapitalize = "none"
               onChangeText = {(city)=>this.setState({city})}
               value={this.state.city.toString()}/>
            
            <TextInput style = {styles.input}
               underlineColorAndroid = "transparent"
               placeholder = "Country"
               placeholderTextColor = "#9a73ef"
               autoCapitalize = "none"
               onChangeText = {(country)=>this.setState({country})}
               value={this.state.country.toString()}/>

            <TextInput style = {styles.input} keyboardType = 'numeric'
               underlineColorAndroid = "transparent"
               placeholder = "Rating"
               placeholderTextColor = "#9a73ef"
               autoCapitalize = "none"
               onChangeText = {(rating) => this.handleRatingChange(rating)}
               value={this.state.ratingAverage.toString()}/>


                <TouchableOpacity style = {styles.submitButton} onPress={()=>this.save()}>
                <Text style = {styles.submitButtonText}> Save </Text>
                </TouchableOpacity>
                <TouchableOpacity style = {styles.submitButton} onPress={()=>this.delete()}>
                <Text style = {styles.submitButtonText}> Delete </Text>

                 </TouchableOpacity> 

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
      },
    input: {
       margin: 15,
       height: 40,
       borderColor: '#7a42f4',
       borderWidth: 1,
       paddingLeft: 10
    },
    submitButton: {
       backgroundColor: '#7a42f4',
       padding: 10,
       margin: 15,
       height: 40,
    },
    submitButtonText:{
       color: 'white'
    },
    chart: {
        width: 200,
        height: 200,
    }
 })
