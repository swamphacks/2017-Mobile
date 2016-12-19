import React, { Component } from 'react';
import { View, StyleSheet, ScrollView, ListView, Text } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

class Filter extends Component {
  render () {
    return (
      <ScrollView keyboardShouldPersistTaps style={styles.scrollView}>
        <Text>Filter</Text>
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

export default Filter
