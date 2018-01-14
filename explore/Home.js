import React, { Component } from 'react';
import { NavigationActions } from 'react-navigation';
import firebase from 'firebase';
import { LoginForm } from './LoginForm';
import { DestinationsList } from './DestinationsList';
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

export default class HomeScreen extends Component {
    constructor(props) {
      super(props);
      this.state = {  
        loggedIn : false
      };
    }


    componentWillMount() {
        firebase.initializeApp({
            apiKey: 'AIzaSyDY1AG-hCcgFRcXbqa5xLafRxMuJDa6XP4',
            authDomain: 'explore-ee9b3.firebaseapp.com',
            databaseURL: 'https://explore-ee9b3.firebaseio.com',
            projectId: 'explore-ee9b3',
            storageBucket: 'explore-ee9b3.appspot.com',
            messagingSenderId: '488721145786'
        });
       
     //     this.loginOrSeeList();
          

    }

    checkLogIn() {
        // firebase.auth().signOut().then(() => {
        // });
        var logged;
        firebase.auth().onAuthStateChanged(function(user) {
            if (user) {
                logged = true;
            } else {
                logged = false;
            }
          });
          this.setState({loggedIn : logged});
          console.warn(this.state.loggedIn);
    }

    loginOrSeeList() {
       if(this.state.loggedIn == true) {
           this.props.navigation.navigate("DestinationsList");
        } else {
            this.props.navigation.navigate("LoginForm");            
        }
    }

    render() {
        // if(this.state.loggedIn == false) {
        //     return <LoginForm />
            
        // }
        // while(this.state.loggedIn == false) {
        //     console.warn("dshdaj");
        //     this.checkLogIn();
        // }
       
        return(
            <View style={{flex: 1}}>
              <LoginForm />
            </View>

        );
    }
}
