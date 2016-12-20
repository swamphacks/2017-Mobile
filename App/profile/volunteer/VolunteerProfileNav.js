import React, { Component } from 'react';
import { Navigator, StyleSheet, Text, TouchableHighlight } from 'react-native';
import VolunteerProfile from './VolunteerProfile';
import * as firebase from "firebase";

const initialRoute = {component: VolunteerProfile};
let context = this;

class VolunteerProfileNav extends Component {
  constructor () {
    super();
    this.renderScene = this.renderScene.bind(this);
  }
  renderScene (route, navigator) {
    return (
      <route.component navigator={navigator} {...route.passProps} />
    )
  }

  async logout() {
        try {
          console.log('doing it');
            await firebase.auth().signOut();
            this.props.navigator.pop();
        } catch (error) {
            console.log(error);
        }
    }

  render () {
    console.log('gonna do it');
    return (
      <Navigator
        navigationBar = {
          <Navigator.NavigationBar routeMapper={
          {
            LeftButton: (route, navigator, index, navState) =>
            {
              return (
                <TouchableHighlight onPress={() => this.logout()}>
                  <Text>dotdotdot</Text>
                </TouchableHighlight>
              );
            },
            RightButton: (route, navigator, index, navState) =>
            {
               return (
                 <Text></Text>
               );
            },
            Title: (route, navigator, index, navState) =>
            {
              return (
                <Text style={styles.titleText}>Profile</Text>
              );
            },
          }
        }
        style={styles.navBar}
      />}
    initialRoute={initialRoute}
    renderScene={this.renderScene.bind(this)} />
    )
  }
}

let styles = StyleSheet.create({
  titleText: {
    fontSize: 20,
    marginTop: 10
  },
  navBar: {
    backgroundColor: 'white'
  }
})

export default VolunteerProfileNav
