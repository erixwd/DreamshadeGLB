import React, { useEffect, useRef } from 'react';
import { View, StyleSheet, Dimensions, Animated } from 'react-native';

const { height } = Dimensions.get('window');
const radius = height / 7;

const Clock: React.FC = () => {
  const minuteHand = useRef(new Animated.Value(0)).current;
  const hourHand = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    const interval = setInterval(() => {
      const now = new Date();
      const seconds = now.getSeconds();
      const minutes = now.getMinutes();
      const hours = now.getHours() % 12;

      Animated.timing(minuteHand, {
        toValue: (minutes * 360) / 60 + (seconds * 6) / 60,
        duration: 500,
        useNativeDriver: true,
      }).start();

      Animated.timing(hourHand, {
        toValue: (hours * 360) / 12 + (minutes * 30) / 60,
        duration: 500,
        useNativeDriver: true,
      }).start();
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  const interpolateRotation = (animatedValue: Animated.Value) =>
    animatedValue.interpolate({
      inputRange: [0, 360],
      outputRange: ['0deg', '360deg'],
    });

  return (
    <View style={styles.container}>
      <View style={styles.clockFace}>
        <Animated.View
          style={[
            styles.minuteHand,
            { transform: [{ rotate: interpolateRotation(minuteHand) }] },
          ]}
        />
        <Animated.View
          style={[
            styles.hourHand,
            { transform: [{ rotate: interpolateRotation(hourHand) }] },
          ]}
        />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  clockFace: {
    width: radius * 2,
    height: radius * 2,
    borderRadius: radius,
    backgroundColor: 'black',
    justifyContent: 'center',
    alignItems: 'center', // Centering the clock hands
    shadowColor: 'black',
    shadowOpacity: 1,
    elevation: 80,
  },
  minuteHand: {
    position: 'absolute',
    width: 2,
    height: radius * 0.9, // 90% of the radius
    backgroundColor: 'white',
    top: radius * 0.5, // Adjusting the pivot point
  },
  hourHand: {
    position: 'absolute',
    width: 4,
    height: radius * 0.9, // Shorter than minute hand
    backgroundColor: 'white',
    top: radius * 0.5, // Adjusting the pivot point
  },
});

export default Clock;
