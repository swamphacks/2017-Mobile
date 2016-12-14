/**
 * @providesModule HSNavTitleComponent
 */

import React from 'react'
import { View } from 'react-native'
import { Text } from 'react-native-elements'

const NavTitleComponent = () => (
  <View>
    <Text>{this.props.title}</Text>
  </View>
)

export default NavTitleComponent
