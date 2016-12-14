import React, { Component } from 'react';
import { View, StyleSheet, Text } from 'react-native';
import colors from 'HSColors';

class Sponsor extends Component{
  render() {
    return (
      <Text>{this.props.name}</Text>
    );
  }
}

Sponsor.propTypes = {
  name: React.PropTypes.string
};

export default Sponsor;
