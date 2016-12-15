import React, { Component } from 'react';
import { View } from 'react-native';
import { List, ListItem, SideMenu } from 'react-native-elements';
import App from './App';

class AppRootContainer extends Component {
  constructor () {
    super();
  }

  render () {
    return ( <App/> )
  }
}

export default AppRootContainer
