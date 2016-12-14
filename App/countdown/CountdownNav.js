import React, { Component } from 'react';
import { Navigator, StyleSheet, Text } from 'react-native';
import Countdown from './Countdown';

const initialRoute = {component: Countdown, name: 'countdown'};

class CountdownNav extends Component {
  constructor () {
    super();
    this.renderScene = this.renderScene.bind(this);
  }
  renderScene (route, navigator) {
    const { toggleSideMenu } = this.props;
    return (
      <route.component toggleSideMenu={toggleSideMenu} navigator={navigator} {...route.passProps} />
    )
  }
  render () {
    const { toggleSideMenu } = this.props
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
                <Text style={styles.titleText}>Countdown</Text>
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

export default CountdownNav
