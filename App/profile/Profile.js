import React, { Component } from 'react';
import { ScrollView, View, StyleSheet } from 'react-native';
import colors from 'HSColors';
import Icon from 'react-native-vector-icons/MaterialIcons';

import {
  Button,
  Text,
  FormInput,
  FormLabel,
  CheckBox
} from 'react-native-elements';

let styles = {};

class Profile extends Component {
  render () {
    return (
      <ScrollView style={{backgroundColor: 'white'}} keyboardShouldPersistTaps>
        <View>
        </View>
      </ScrollView>
    )
  }
}

styles = StyleSheet.create({
  headingContainer: {
    marginTop: 60,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    backgroundColor: colors.secondary2
  },
  heading: {
    color: 'white',
    marginTop: 10,
    fontSize: 22
  },
  labelContainerStyle: {
    marginTop: 8
  }
})

export default Profile
