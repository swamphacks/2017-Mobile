import React, { Component }from 'react';
import { AppRegistry, Navigator } from 'react-native';

import App from './App/App';
import Login from './App/login/Login';

import * as firebase from "firebase";
import Firebase from "./App/firebase/Firebase";

class SwamphacksMobile1 extends Component {
  constructor(props) {
    super(props);
    Firebase.initialise();
    this.getInitialView();
    this.state = {
      userLoaded: false,
      initialView: null
    };

    this.getInitialView = this.getInitialView.bind(this);
  }

  getInitialView() {
    firebase.auth().onAuthStateChanged((user) => {
      let initialView = user ? "App" : "Login";
      this.setState({
        userLoaded: true,
        initialView: initialView
      })
    });
  }

  static renderScene(route, navigator) {
    switch (route.name) {
      case "App":
        return (<App navigator={navigator} {...route.passProps}/>);
        break;
      case "Login":
        return (<Login navigator={navigator} {...route.passProps}/>);
        break;
    }
  }

  static configureScene(route) {
    if (route.sceneConfig) {
      return (route.sceneConfig);
    } else {
      return ({
        ...Navigator.SceneConfigs.HorizontalSwipeJump,
        gestures: {}
      });
    }
  }

  render() {
    if (this.state.userLoaded) {
      return (
          <Navigator
              initialRoute={{name: this.state.initialView}}
              renderScene={SwamphacksMobile1.renderScene}
              configureScene={SwamphacksMobile1.configureScene}
          />);
    } else {
      return null;
    }
  }
}

AppRegistry.registerComponent('SwamphacksMobile1', () => SwamphacksMobile1);
