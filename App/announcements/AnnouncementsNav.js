import React, { Component } from 'react';
import { Navigator, StyleSheet, Text, TouchableHighlight } from 'react-native';
import Announcements from './Announcements';
import FilterNav from "./FilterNav";

const initialRoute = {component: Announcements};

class AnnouncementsNav extends Component {
  constructor () {
    super();
    this.renderScene = this.renderScene.bind(this);
  }

  renderScene (route, navigator) {
    return (
      <route.component navigator={navigator} {...route.passProps} />
    )
  }

  openFilter(navigator){
    this.props.navigator.push({
      title: 'filter',
      component: FilterNav,
      passProps: {navigator}
    });
  }

  render () {
    return (
      <Navigator
        navigationBar = {
          <Navigator.NavigationBar routeMapper={
          {
            LeftButton: (route, navigator, index, navState) =>
            {
              return (
                <TouchableHighlight onPress={() => this.openFilter(navigator)}>
                  <Text>Filter</Text>
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
                <Text style={styles.titleText}>Announcements</Text>
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

styles = StyleSheet.create({
  titleText: {
    fontSize: 20,
    marginTop: 10
  },
  navBar: {
    backgroundColor: 'white'
  }
})

export default AnnouncementsNav
