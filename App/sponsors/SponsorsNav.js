import React, { Component } from 'react';
import { Navigator, Text, StyleSheet, TouchableHighlight } from 'react-native';
import Sponsors from './Sponsors';

const initialRoute = {component: Sponsors, index: 0};

class SponsorsNav extends Component {
  constructor () {
    super();
    this.renderScene = this.renderScene.bind(this);
  }
  
  renderScene (route, navigator) {
    return (
      <route.component navigator={navigator} {...route.passProps} />
    )
  }

  render () {
    return (
      <Navigator
        navigationBar = {
          <Navigator.NavigationBar routeMapper={
          {
            LeftButton: (route, navigator, index, navState) =>
            {
              if (route.index === 0) {
                return null;
              } else {
                return (
                  <TouchableHighlight onPress={() => navigator.pop()}>
                    <Text>Back</Text>
                  </TouchableHighlight>
                );
              }
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
                <Text style={styles.titleText}>Sponsors</Text>
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

export default SponsorsNav
