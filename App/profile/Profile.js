import React, { Component } from 'react';
import { ScrollView, View, StyleSheet } from 'react-native';
import colors from 'HSColors';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { Button, Text, FormInput, FormLabel, CheckBox } from 'react-native-elements';

import * as firebase from "firebase";

class Profile extends Component {
  constructor(props) {
      super(props);

      this.state = {
          uid: "",
          name: "",
          email: "",
          qr: ""
      };
  }

  async componentDidMount() {
      try {
        let user = await firebase.auth().currentUser;

        this.setState({
            uid: user.uid,
            email: user.email
        });

      } catch (error) {
          console.log(error);
      }
    }

  render () {
    return (
      <ScrollView style={styles.scrollView} keyboardShouldPersistTaps>
        <View>
          <Text>{this.state.email}</Text>
        </View>
      </ScrollView>
    )
  }
}

let styles = StyleSheet.create({
  scrollView: {
    marginTop: 65,
    backgroundColor: 'white'
  },

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
