import React, { Component } from 'react';
import { ScrollView, View, StyleSheet } from 'react-native';
import colors from 'HSColors';
import Icon from 'react-native-vector-icons/MaterialIcons';

import {
  PricingCard,
  Text
} from 'react-native-elements';

import Sponsor from "./Sponsor";

let styles = {};

class Sponsors extends Component {
  render () {
    return (
      <ScrollView style={{backgroundColor: 'white'}}>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Heron Tier</Text>
        </View>
        <View style={styles.container}>
          <Sponsor name='Infinite Energy' />
          <Sponsor name='Facebook' />
          <Sponsor name='StateFarm' />
          <Sponsor name='Linode' />
        </View>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Turtle Tier</Text>
        </View>
        <View style={styles.container}>
          <Sponsor name='GE' />
          <Sponsor name='American Express' />
          <Sponsor name='Clarifai' />
        </View>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Lilypad Tier</Text>
        </View>
        <View style={styles.container}>
          <Sponsor name='Ultimate Software' />
        </View>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Partners</Text>
        </View>
        <View style={styles.container}>
          <Sponsor name='MLH' />
        </View>
      </ScrollView>
    )
  }
}

styles = StyleSheet.create({
  container: {
    margin: 15
  },
  headingContainer: {
    marginTop: 40,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    backgroundColor: colors.grey2
  },
  heading: {
    color: 'white',
    marginTop: 10,
    fontSize: 22
  }
})

export default Sponsors
