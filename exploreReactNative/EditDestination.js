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
  Linking
} from 'react-native';
export default class EditDestination extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            id:0,
            name: "",
            country: ""
        };
        if (this.props.navigation.state.params.id !== undefined) {
            var toEdit = this.props.navigation.state.params;
            this.state.id = toEdit.id;
            this.state.name = toEdit.name;
            this.state.country = toEdit.country;
        }

    }

    save() {
        var element = this.state;
        for (var i = 0; i < attractionsArray.length; i++) {
            if (attractionsArray[i].id === element.id) {
                attractionsArray[i] = element;
            }
        }

    Linking.openURL("mailto:andrapop291@gmail.com?subject=ReactAppMail&body=" + JSON.stringify(element));
    this.props.navigation.navigate("Home");
    }

    render() {
        return (
            <View>
                <TextInput onChangeText={(name)=>this.setState({name})} value={this.state.name}/>
                <TextInput onChangeText={(country)=>this.setState({country})}
                           value={this.state.country.toString()}/>
                <Button title="save" onPress={()=>this.save()}/>
            </View>
        );
    }
};
