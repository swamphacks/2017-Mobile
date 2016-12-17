import React, { Component } from 'react';
import { Navigator, StyleSheet, Text, TouchableHighlight } from 'react-native';
import Filter from './Filter';

const initialRoute = {component: Filter};

class FilterNav extends Component {
  constructor () {
    super();
    this.renderScene = this.renderScene.bind(this);
  }

  renderScene (route, navigator) {
    return (
      <route.component navigator={navigator} {...route.passProps} />
    )
  }

  applyFilters(){
    console.log('yee');
  }

  render () {
    console.log('yeezy');
    return (
      <Navigator
        navigationBar = {
          <Navigator.NavigationBar routeMapper={
          {
            LeftButton: (route, navigator, index, navState) =>
            {
              return (
                <TouchableHighlight onPress={() => this.props.navigator.pop()}>
                  <Text>Cancel</Text>
                </TouchableHighlight>
              );
            },
            RightButton: (route, navigator, index, navState) =>
            {
               return (
                 <TouchableHighlight onPress={() => this.applyFilters()}>
                   <Text>Apply</Text>
                 </TouchableHighlight>
               );
            },
            Title: (route, navigator, index, navState) =>
            {
              return (
                <Text style={styles.titleText}>Filter</Text>
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

export default FilterNav
