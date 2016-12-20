import React, { Component } from 'react';
import { StyleSheet, Platform, Navigator } from 'react-native';
import { Tabs, Tab } from 'react-native-elements';
import fonts from 'HSFonts';

import Events from './events/EventsRootContainer';
import Announcements from './announcements/AnnouncementsRootContainer';
import Countdown from './countdown/CountdownRootContainer';
import Sponsors from './sponsors/SponsorsRootContainer';
import Profile from './profile/hacker/ProfileRootContainer';
import VolunteerProfile from './profile/volunteer/VolunteerProfileRootContainer';

import * as firebase from "firebase";

class App extends Component {
   constructor () {
    super();
    this.state = {
      selectedTab: 'countdown',
      volunteer: 'false'
    };

    if(this.state.volunteer === null){
      setVolunteerState(false);
    } else if(this.state.volunteer === true){
      setVolunteerState(true);
    } else if(this.state.volunteer === false){
      console.log('aw man');
    }
    this.changeTab = this.changeTab.bind(this);
  }
  async componentDidMount() {
      try {
        let email = await firebase.auth().currentUser.email.replace(".", "").replace("@", "");
        var isVol = false;
        await firebase.database().ref('/confirmed-attendees/' + email).once('value').then(function(snapshot) {
          isVol = snapshot.val().volunteer;
          console.log(snapshot.val().volunteer);
        });

        this.setState({
            volunteer: isVol
        });

      } catch (error) {
          console.log(error);
      }
    }
  changeTab (selectedTab) {
    this.setState({
      selectedTab
    });
  }
  setVolunteerState(volunteer){
    this.setState({
      volunteer
    });
  }
  render () {
    const { selectedTab } = this.state;
    if(this.state.volunteer === true){
      return (
        <Tabs hidesTabTouch>
          <Tab
            titleStyle={[styles.titleStyle]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'events'}
            title={selectedTab === 'events' ? 'EVENTS' : null}
            onPress={() => this.changeTab('events')}>
            <Events />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'announcements' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'announcements'}
            title={selectedTab === 'announcements' ? 'ANNOUNCEMENTS' : null}
            onPress={() => this.changeTab('announcements')}>
            <Announcements navigator={this.props.navigator}/>
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'countdown' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'countdown'}
            title={selectedTab === 'countdown' ? 'COUNTDOWN' : null}
            onPress={() => this.changeTab('countdown')}>
            <Countdown />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'sponsors' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'sponsors'}
            title={selectedTab === 'sponsors' ? 'SPONSORS' : null}
            onPress={() => this.changeTab('sponsors')}>
            <Sponsors />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'profile' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 8}]}
            selected={selectedTab === 'profile'}
            title={selectedTab === 'profile' ? 'PROFILE' : null}
            onPress={() => this.changeTab('profile')}>
            <VolunteerProfile navigator={this.props.navigator}/>
          </Tab>
        </Tabs>
      )
    } else {
      return (
        <Tabs hidesTabTouch>
          <Tab
            titleStyle={[styles.titleStyle]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'events'}
            title={selectedTab === 'events' ? 'EVENTS' : null}
            onPress={() => this.changeTab('events')}>
            <Events />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'announcements' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'announcements'}
            title={selectedTab === 'announcements' ? 'ANNOUNCEMENTS' : null}
            onPress={() => this.changeTab('announcements')}>
            <Announcements navigator={this.props.navigator}/>
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'countdown' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'countdown'}
            title={selectedTab === 'countdown' ? 'COUNTDOWN' : null}
            onPress={() => this.changeTab('countdown')}>
            <Countdown />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'sponsors' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
            selected={selectedTab === 'sponsors'}
            title={selectedTab === 'sponsors' ? 'SPONSORS' : null}
            onPress={() => this.changeTab('sponsors')}>
            <Sponsors />
          </Tab>
          <Tab
            tabStyle={selectedTab !== 'profile' && { marginBottom: -6 }}
            titleStyle={[styles.titleStyle, {marginTop: -1}]}
            selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 8}]}
            selected={selectedTab === 'profile'}
            title={selectedTab === 'profile' ? 'PROFILE' : null}
            onPress={() => this.changeTab('profile')}>
            <Profile navigator={this.props.navigator}/>
          </Tab>
        </Tabs>
      )
    }
  }
}

let styles = StyleSheet.create({
  titleStyle: {
    ...Platform.select({
      ios: {
        fontFamily: fonts.ios.black
      }
    })
  }
})

export default App
