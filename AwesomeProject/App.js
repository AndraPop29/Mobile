/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View
} from 'react-native';

import {StackNavigator} from 'react-navigation';
import DestinationsList from './DestinationsList.js';
import EditDestination from './EditDestination.js';
import Statistics from './Statistics.js';
import LoginForm from './LoginForm.js'
import HomeScreen from './Home.js';
global.items = [];
global.attractionsArray = [{id: 1, name: "Colloseum", city: "Rome", country: "Italy", ratingSum: 0, ratingAverage: 0, noOfRatings: 0},
{id: 2, name: "Eiffel Tower", city: "Paris", country: "France", ratingSum: 0, ratingAverage: 0, noOfRatings: 0},{id: 3, name: "FSEGA", city: "Cluj-Napoca", country:"Romania", ratingSum: 0, ratingAverage: 0, noOfRatings: 0}];
global.count = 4;
global.ratingsArray = [];
const ModalStack = StackNavigator({
  Home:{
    screen: LoginForm,
  },
  DestinationsList:{
    screen: DestinationsList,
  },
    Destination: {
        path: 'editDestinations/:destination',
        screen: EditDestination,
    },
    Statistics: {
      path: 'statistics',
      screen: Statistics,
    }
});

export default ModalStack;


const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
