import React, { Component } from 'react';
import { Navigator } from 'react-native';
import Announcements from './Announcements';
import navigationBar from 'HSNavBar';

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
  render () {
    return (
      <Navigator
        navigationBar={navigationBar()}
        initialRoute={initialRoute}
        renderScene={this.renderScene.bind(this)} />
    )
  }
}

export default AnnouncementsNav
