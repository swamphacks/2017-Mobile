import React, { Component } from 'react';
import { View, StyleSheet, ScrollView, ListView } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

import { List, ListItem, Text, SearchBar } from 'react-native-elements';

const log = () => console.log('this is an example method');

const announcements = [
  {
    title: 'Lunch',
    description: 'FOOOOOOOD',
    time: 'Sun 9:00AM',
    tag: 'food'
  },
  {
    title: 'Lunch',
    description: 'FOOOOOOOD',
    time: 'Sun 9:00AM',
    tag: 'food'
  },
  {
    title: 'Lunch',
    description: 'FOOOOOOOD',
    time: 'Sun 9:00AM',
    tag: 'food'
  },
  {
    title: 'Lunch',
    description: 'FOOOOOOOD',
    time: 'Sun 9:00AM',
    tag: 'food'
  },{
    title: 'Lunch',
    description: 'FOOOOOOOD',
    time: 'Sun 9:00AM',
    tag: 'food'
  }
];

class Announcements extends Component {
  constructor () {
    super();
    const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
    this.state = {
      dataSource: ds.cloneWithRows(announcements)
    };
    this.renderRow = this.renderRow.bind(this);
  }
  renderRow (rowData, sectionID) {
    return (
      <ListItem
        key={sectionID}
        onPress={log}
        title={rowData.title}
        subtitle={rowData.description}
        time={rowData.time}
        tag={rowData.tag}
      />
    )
  }
  render () {
    return (
      <ScrollView keyboardShouldPersistTaps style={styles.scrollView}>
        <List>
          <ListView
            renderRow={this.renderRow}
            dataSource={this.state.dataSource}
            />
        </List>
      </ScrollView>
    )
  }
}

let styles = StyleSheet.create({
  scrollView: {
    backgroundColor: 'white',
    marginTop: 65
  },
  container: {
    marginTop: 60
  },
  heading: {
    color: 'white',
    marginTop: 10,
    fontSize: 22
  },
  hero: {
    marginTop: 60,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    backgroundColor: '#69DDFF'
  }
})

export default Announcements
