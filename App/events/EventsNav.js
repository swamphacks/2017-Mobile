import React, { Component } from 'react';
import { Navigator, StyleSheet, Text } from 'react-native';
import Events from './Events';

const initialRoute = {component: Events};

class EventsNav extends Component {
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
              return (
                <Text></Text>
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
                <Text style={styles.titleText}>Events</Text>
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

export default EventsNav
