import React, { Component } from 'react';
import { ScrollView, View, StyleSheet, TouchableHighlight, Image, Text } from 'react-native';
import colors from 'HSColors';
import Icon from 'react-native-vector-icons/MaterialIcons';

import Sponsor from "./Sponsor";
import SponsorDetail from "./SponsorDetail";
import * as sponsors from "./SponsorInfo";

var herons = sponsors.HERONS;
var turtles = sponsors.TURTLES;
var lilypads = sponsors.LILYPADS;

class Sponsors extends Component {
  showSponsorDetail(sponsor) {
    this.props.navigator.push({
      title: sponsor.name,
      component: SponsorDetail,
      passProps: {sponsor}
    });
  }

  render () {
    return (
      <ScrollView style={styles.scrollView}>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Heron Tier</Text>
        </View>
        <View style={styles.container}>
          <TouchableHighlight onPress={() => this.showSponsorDetail(herons[0])}  underlayColor='#dddddd'>
            <View>
              <Sponsor name='Infinite Energy' />
            </View>
          </TouchableHighlight>
          <Sponsor name='Facebook' />
          <Sponsor name='StateFarm' />
          <Sponsor name='Linode' />
        </View>
        <View style={styles.headingContainer}>
          <Text style={styles.heading}>Turtle Tier</Text>
        </View>
        <View style={styles.container}>
        <TouchableHighlight onPress={() => this.showSponsorDetail(turtles[0])}  underlayColor='#dddddd'>
          <View>
            <Sponsor name='GE' />
          </View>
        </TouchableHighlight>
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

let styles = StyleSheet.create({
  container: {
    margin: 15
  },
  headingContainer: {
    marginTop: 0,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    backgroundColor: colors.grey2
  },
  heading: {
    color: 'white',
    marginTop: 10,
    fontSize: 22
  },
  scrollView: {
    marginTop: 60,
    backgroundColor: colors.white
  }
})

export default Sponsors
