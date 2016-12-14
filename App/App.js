import React, { Component } from 'react';
import { StyleSheet, Platform } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import colors from 'HSColors';
import fonts from 'HSFonts';

import Events from './events/EventsRootContainer';
import Announcements from './announcements/AnnouncementsRootContainer';
import Countdown from './countdown/CountdownRootContainer';
import Sponsors from './sponsors/SponsorsRootContainer';
import Profile from './profile/ProfileRootContainer';

import { Tabs, Tab } from 'react-native-elements';

let styles = {};

class App extends Component {
  constructor () {
    super();
    this.state = {
      selectedTab: 'countdown'
    };
    this.changeTab = this.changeTab.bind(this);
  }
  changeTab (selectedTab) {
    this.setState({
      selectedTab
    });
  }
  render () {
    const { toggleSideMenu } = this.props;
    const { selectedTab } = this.state;
    return (
      <Tabs hidesTabTouch>
        <Tab
          titleStyle={[styles.titleStyle]}
          selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
          selected={selectedTab === 'events'}
          title={selectedTab === 'events' ? 'EVENTS' : null}
          onPress={() => this.changeTab('events')}>
          <Events toggleSideMenu={toggleSideMenu} />
        </Tab>
        <Tab
          tabStyle={selectedTab !== 'announcements' && { marginBottom: -6 }}
          titleStyle={[styles.titleStyle, {marginTop: -1}]}
          selectedTitleStyle={[styles.titleSelected, {marginTop: -3, marginBottom: 7}]}
          selected={selectedTab === 'announcements'}
          title={selectedTab === 'announcements' ? 'ANNOUNCEMENTS' : null}
          onPress={() => this.changeTab('announcements')}>
          <Announcements />
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
          <Profile />
        </Tab>
      </Tabs>

    )
  }
}

styles = StyleSheet.create({
  titleStyle: {
    ...Platform.select({
      ios: {
        fontFamily: fonts.ios.black
      }
    })
  }
})

export default App
