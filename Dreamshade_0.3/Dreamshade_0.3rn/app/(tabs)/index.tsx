import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, Dimensions, Pressable, Image, Animated, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';
import Clock from '../Clock';

const { width, height } = Dimensions.get('window');
const boxWidth = width * 0.6;
const boxHeight = height * 1; // Height of the settings box
const StOutHeight = 50; // Height of the part that sticks out

const Index: React.FC = () => {
  const translateY = useRef(new Animated.Value(height - StOutHeight)).current; // Initial position slightly above the bottom
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);

  const toggleSettings = () => {
    Animated.timing(translateY, {
      toValue: isSettingsOpen ? height - StOutHeight : height - boxHeight + 100,
      duration: 300,
      useNativeDriver: true,
    }).start();
    setIsSettingsOpen(!isSettingsOpen);
  };

  return (
    
    <View style={styles.container}>

      <View style={styles.content}>
        <View style={styles.header}>
          <View style={styles.row}>
            <Text style={styles.LocationCt}>Trieste</Text>
            <Text style={styles.LocationNt}> Italia</Text>
          </View>
          <Text>45.6495° N, 13.7768° E</Text>
        </View>

        <View style={styles.clockContainer}>
          <Clock />
        </View>

        <View style={styles.footer}>
          <Pressable onPress={toggleSettings}>
            <View style={styles.box}>
              <View style={styles.boxText}>
                <View style={styles.row}>
                  <Image source={require('../../assets/images/sun.png')} style={styles.image} />
                  <View style={styles.paddingHor}></View>
                  <Text style={styles.RisSet}>Sunrise</Text>
                </View>
                <Text style={styles.RisSetTime}>05:46</Text>
              </View>
            </View>
          </Pressable>

          <Pressable onPress={toggleSettings}>
            <View style={styles.box}>
              <View style={styles.boxText}>
                <View style={styles.row}>
                  <Image source={require('../../assets/images/crescent-moon.png')} style={styles.image} />
                  <View style={styles.paddingHor}></View>
                  <Text style={styles.RisSet}>Sunset</Text>
                </View>
                <Text style={styles.RisSetTime}>19:24</Text>
              </View>
            </View>
          </Pressable>
        </View>

        <Animated.View style={[styles.settingsBox, { transform: [{ translateY }] }]}>
          <BlurView intensity={150} style={StyleSheet.absoluteFill}>
            <LinearGradient
              colors={['rgba(180, 180, 180, 0.8)', 'rgba(200, 200, 210, 0.8)']}
              style={styles.settingsGradient}
            >
              <Pressable style={styles.settingsHeader} onPress={toggleSettings}>
                <Text style={styles.settingsHeaderText}>{isSettingsOpen ? "Close Settings" : "Open Settings"}</Text>
              </Pressable>
              <ScrollView contentContainerStyle={styles.settingsContent}>
                <Text style={styles.settingItem}>Setting 1</Text>
                <Text style={styles.settingItem}>Setting 2</Text>
                <Text style={styles.settingItem}>Setting 3</Text>
                <Text style={styles.settingItem}>Setting 4</Text>
                <Text style={styles.settingItem}>Setting 5</Text>
                <Text style={styles.settingItem}>Setting 6</Text>
                <Text style={styles.settingItem}>Setting 7</Text>
                <Text style={styles.settingItem}>Setting 8</Text>
                <Text style={styles.settingItem}>Setting 9</Text>
                <Text style={styles.settingItem}>Setting 10</Text>
                <Text style={styles.settingItem}>Setting 11</Text>
              </ScrollView>
            </LinearGradient>
          </BlurView>
        </Animated.View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  background: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
  },
  Center: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  row: {
    flexDirection: 'row',
  },
  header: {
    alignItems: 'center',
    marginTop: 96,
  },
  footer: {
    alignItems: 'center',
    marginBottom: 145,
  },
  paddingVert: {
    height: 12,
  },
  paddingHor: {
    width: 12,
  },
  container: {
    flex: 1,
    backgroundColor: 'transparent',
    justifyContent: 'space-between',
  },
  content: {
    flex: 1,
    width: '100%',
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  LocationCt: {
    paddingBottom: 10,
    fontFamily: 'Poppins',
    fontSize: 26,
    fontWeight: 'bold',
  },
  LocationNt: {
    fontFamily: 'Poppins',
    fontSize: 26,
  },
  clockContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  box: {
    width: boxWidth,
    height: 50,
    justifyContent: 'center',
    backgroundColor: 'transparent',
  },
  boxText: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  RisSet: {
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: 'bold',
  },
  RisSetTime: {
    fontFamily: 'Poppins',
    fontSize: 20,
    paddingRight: 12,
  },
  image: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 30,
    height: 30,
  },
  settingsBox: {
    position: 'absolute',
    bottom: 0, // Start at the bottom
    width: '100%',
    height: boxHeight,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    elevation: 20, // Adding shadow for better visual cue
  },
  settingsGradient: {
    flex: 1,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
  },
  settingsHeader: {
    height: StOutHeight, // Making sure the header sticks out
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'transparent',
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
  },
  settingsHeaderText: {
    color: '#000',
    fontSize: 14,
  },
  settingsContent: {
    padding: 20,
  },
  settingItem: {
    fontFamily: 'Poppins',
    marginBottom: 20,
    fontSize: 18,
  },
});

export default Index;
