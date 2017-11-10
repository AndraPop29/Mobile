'use-strict';

import React, { Component } from 'react';
import { NavigationActions } from 'react-navigation';
import {
  View,
  ListView,
  Text,
  TouchableHighlight
} from 'react-native';

export default class DestinationsList extends Component {
  constructor(props) {
    super(props);
    var dataSource = new ListView.DataSource({rowHasChanged:(r1,r2) => r1.id != r2.id});
    this.state = {
      dataSource: dataSource.cloneWithRows(attractionsArray)
    }
  }
  edit(destination){
      this.props.navigation.navigate("Destination", destination);
  }
 
  renderRow(destination){
        return(
            <TouchableHighlight onPress={() => this.edit(destination)}>
            <View>
                <Text>{destination.name}</Text>
            </View>
            </TouchableHighlight>
      );
  }
  
  render() {
    return(
      <View style={{flex: 1, backgroundColor: 'powderblue'}}>
        <ListView dataSource={this.state.dataSource} renderRow={this.renderRow.bind(this)}/>
      </View>
    );
  }
  
};
