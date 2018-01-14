'use-strict';

import React from 'react';
import firebase from 'firebase';

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
  AsyncStorage
} from 'react-native';
import PropTypes from 'prop-types';
import { Pie } from 'react-native-pathjs-charts';
import DataManager from './DataManager.js';
var ratingChanged = false;                      
export default class EditDestination extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            id:0,
            name: "",
            city:"",
            country:"",
            ratingAverage: 0,
            userRole: null,
            userKey: null
        };
        this.itemsRef = firebase.database().ref('/touristAttractions');
        this.state.userRole = this.props.navigation.state.params.userRole;    
        this.state.ratingAverage = 0;   
        
        
        if (this.props.navigation.state.params.dest.id !== undefined) {
            var toEdit = this.props.navigation.state.params.dest;
            this.state.id = toEdit.id;
            this.state.name = toEdit.name;
            this.state.city = toEdit.city;
            this.state.country = toEdit.country;
        }

    }

    async setupNotifications() {
        console.warn("hgjhgjhghjg");
        let result = await   
        Permissions.askAsync(Permissions.NOTIFICATIONS);
        if (Constants.lisDevice && resut.status === 'granted') {
         console.log('Notification permissions granted.')
        }
        const localNotification = {
            title: '',
            body: '', // (string) — body text of the notification.
            ios: { // (optional) (object) — notification configuration specific to iOS.
              sound: true // (optional) (boolean) — if true, play a sound. Default: false.
            },
          };
    
          let t = new Date();
          t.setSeconds(t.getSeconds() + 10);
          const schedulingOptions = {
              time: t, // (date or number) — A Date object representing when to fire the notification or a number in Unix epoch time. Example: (new Date()).getTime() + 1000 is one second from now.
              repeat: repeat
            };

            Notifications.scheduleLocalNotificationAsync(localNotification, schedulingOptions);
    }

   


    

    static navigationOptions = ({ navigation}) => ({
        headerTitleStyle :{textAlign: 'center',alignSelf:'center'},
        headerStyle:{
            backgroundColor:'white',
        },
        headerLeft:  <Button title = "Back" onPress={ () => { navigation.goBack() } }  /> 
      });

  

    async getFromAsyncStorage() {
        try {
          const value = await AsyncStorage.getItem("user_key");
          if (value !== null){
            this.setState({userKey : JSON.parse(value)});
            //this.setUserRating();
          }
        } catch (error) {
          console.warn(error);
        }
        try {
            const value = await AsyncStorage.getItem("ratingsArray");
            if (value !== null){
              for(var i = 0; i < JSON.parse(value).length; i ++) {                
                  if(JSON.parse(value)[i].attrId === this.state.id) {
                    var rat = JSON.parse(value)[i].rating
                    this.setState({ratingAverage : rat});                    

                  }
                
              }
            }
          } catch (error) {
            console.warn(error);
          }
    
    }

    save() {
        var dm = new DataManager();
        
        if(this.state.name === "" || this.state.country ==="" || this.state.city ==="") {
            Alert.alert(
                'None of the fields can be empty'
             )
        }
        else if (this.state.id === 0){
                var attr = {
                    name: this.state.name,
                    city: this.state.city,
                    country: this.state.country,
                    ratingAverage: parseInt(this.state.ratingAverage),
                };
                dm.addToFirebase(attr).then(() => {
                    this.props.navigation.state.params.onGoBack();
                    this.props.navigation.goBack(); 
                }).catch(error => {
                    console.warn(error);
                });
               
                      
        }
        else{
            var element = this.state;            
            if(ratingChanged ===true) {
                for (var i = 0; i < global.attractionsArray.length; i++) {
                    if (global.attractionsArray[i].id === element.id) {
                        if(ratingChanged ===true) {
                            var id = element.id;
                            dm.updateUserRating(id, this.state.ratingAverage, this.state.userKey);
                    }
                }
            
            }
        }
        dm.updateAttraction(element).then(() => {
            this.props.navigation.state.params.onGoBack();
            this.props.navigation.goBack();
        });
       
         }
    }

    componentWillMount() {
      
        this.getFromAsyncStorage();
        this.setupNotifications();
    }


    delete() {
        if (this.state.id === 0){        
            Alert.alert(
                'The location was not added, therefore cannot be deleted'
             )
        }   
        else{
            var element = this.state;
            var dm = new DataManager();
            dm.removeFromFirebase(element).then(() => {
                this.props.navigation.state.params.onGoBack();
                this.props.navigation.goBack();
            }).catch(error => {
                console.warn(error);
            }
            );
        
        }
    }
    handleRatingChange(rating) {
        var newRating = rating;
        this.setState({ratingAverage: newRating});
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
        if (this.state.userRole == "ADMIN") {
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
        } else {
            return (
                <View style = {styles.container}>
                <TextInput style = {styles.input}
                   underlineColorAndroid = "transparent"
                   placeholder = "Name"
                   placeholderTextColor = "#9a73ef"
                   autoCapitalize = "none"
                   editable = "false"
                   onChangeText = {(name)=>this.setState({name})}
                   value={this.state.name.toString()}/>
    
    
                <TextInput style = {styles.input}
                   underlineColorAndroid = "transparent"
                   placeholder = "City"
                   placeholderTextColor = "#9a73ef"
                   autoCapitalize = "none"
                   editable = "false"                   
                   onChangeText = {(city)=>this.setState({city})}
                   value={this.state.city.toString()}/>
                
                <TextInput style = {styles.input}
                   underlineColorAndroid = "transparent"
                   placeholder = "Country"
                   placeholderTextColor = "#9a73ef"
                   autoCapitalize = "none"
                   editable = "false"                   
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
    
                </View>
            );

        }
  
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
