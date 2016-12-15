import React, { Component } from 'react';
import { View, StyleSheet, Text } from 'react-native';
import colors from 'HSColors';

class SponsorDetail extends Component{
  render() {
    var sponsor = this.props.sponsor;
    return (
      <View style={styles.container}>
        <Text>{sponsor.logo}</Text>
      </View>
    );
  }
}

var styles = StyleSheet.create({
    container: {
        marginTop: 75,
        alignItems: 'center'
    },
    image: {
        width: 107,
        height: 165,
        padding: 10
    },
    description: {
        padding: 10,
        fontSize: 15,
        color: '#656565'
    }
});

export default SponsorDetail;
