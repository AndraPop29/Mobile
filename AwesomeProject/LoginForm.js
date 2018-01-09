import React, { Component } from 'react';
import { View, Text, Button, AsyncStorage } from 'react-native';
import firebase from 'firebase';
import TitledInput from './common';

//const auth = firebase.auth();

export default class LoginForm extends Component {
    constructor(props) {
        super(props);
        this.state = { email: '', password: '', error: '', loading: false , loggedIn : false};
      }
   
    onLoginPress() {
        this.setState({ error: '', loading: true });
        const { email, password } = this.state;
        firebase.auth().signInWithEmailAndPassword(email, password)
            .then(() => { 
                this.setState({ error: '', loading: false }); 
            })
            .catch(() => {
               this.setState({ error: 'Authentication failed.', loading: false });
            });
    }

    renderButtonOrSpinner() {
        if (this.state.loading) {
            return <Text>Loading</Text>;
        }
        return <Button onPress={this.onLoginPress.bind(this)} title="Log in" />;
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
        //firebase.auth().signOut();
        firebase.auth().onAuthStateChanged( user => {
            if(user) {
                    var userRole = null;
                    if (user.email !== null){
                      firebase.database().ref('/users').once('value', (snap) => {
                        snap.forEach((childSnap) => {
                         if(childSnap.val().email == user.email) {
                            userRole = childSnap.val().role;    
                            AsyncStorage.setItem('user_role', childSnap.val().role);  
                            AsyncStorage.setItem('user_key', JSON.stringify(childSnap.key));         
                            this.props.navigation.navigate("DestinationsList",  { role:  childSnap.val().role});                
                            
                         }
                        });
                       });
                    }
            }
        }
          
        ); 
    }

    render() {
        return (
            <View>
                        <TitledInput 
                            label='Email Address'
                            placeholder='you@domain.com'
                            value={this.state.email}
                            onChangeText={email => this.setState({ email })}
                        />
                        <TitledInput 
                            label='Password'
                            autoCorrect={false}
                            placeholder='*******'
                            secureTextEntry
                            value={this.state.password}
                            onChangeText={password => this.setState({ password })}
                        />
                    <Text style={styles.errorTextStyle}>{this.state.error}</Text>
                    {this.renderButtonOrSpinner()}
            </View>
        );
    }
}
const styles = {
    errorTextStyle: {
        color: '#E64A19',
        alignSelf: 'center',
        paddingTop: 10,
        paddingBottom: 10
    }
};

//export {LoginForm};