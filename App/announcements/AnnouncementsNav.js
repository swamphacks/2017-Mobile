import React, { Component } from 'react';
import { Navigator, StyleSheet, Text, TouchableHighlight } from 'react-native';
import Announcements from './Announcements';
import Filter from "./Filter";

const initialRoute = {component: Announcements, index: 0};

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
    navigator.push({
      title: 'Filter',
      component: Filter,
      passProps: {navigator}
    });
  }

  applyFilters(){
    console.log('yee');
  }

  render () {
    return (
      <Navigator
        navigationBar = {
          <Navigator.NavigationBar routeMapper={
          {
            LeftButton: (route, navigator, index, navState) =>
            {
              if (route.index === 0){
                return (
                  <TouchableHighlight onPress={() => this.openFilter(navigator)}>
                    <Text>Filter</Text>
                  </TouchableHighlight>
                );
              } else {
                return (
                  <TouchableHighlight onPress={() => navigator.pop()}>
                    <Text>Cancel</Text>
                  </TouchableHighlight>
                );
              }
            },
            RightButton: (route, navigator, index, navState) =>
            {
              if (route.index === 0){
                return null;
              } else {
                return (
                  <TouchableHighlight onPress={() => navigator.pop()}>
                    <Text>Apply</Text>
                  </TouchableHighlight>
                );
              }
            },
            Title: (route, navigator, index, navState) =>
            {
              if (route.index === 0){
                return (
                  <Text style={styles.titleText}>Announcements</Text>
                );
              } else {
                return (
                  <Text style={styles.titleText}>Filter</Text>
                );
              }
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
