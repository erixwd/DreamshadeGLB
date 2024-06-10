import React, { useEffect, useState, useCallback } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import * as Font from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import Index from './app/(tabs)/index';
import AddTimeZoneScreen from './app/(tabs)/two';

const Stack = createStackNavigator();

const App: React.FC = () => {
  const [fontsLoaded, setFontsLoaded] = useState(false);

  const loadFonts = async () => {
    await Font.loadAsync({
      'Poppins': require('./assets/fonts/Poppins.ttf'),
    });
    setFontsLoaded(true);
    await SplashScreen.hideAsync();
  };

  useEffect(() => {
    SplashScreen.preventAutoHideAsync();
    loadFonts();
  }, []);

  const onLayoutRootView = useCallback(async () => {
    if (fontsLoaded) {
      await SplashScreen.hideAsync();
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) {
    return null;
  }

  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Index">
        <Stack.Screen
          name="Index"
          component={Index}
          options={{
            headerTitleStyle: {
              fontFamily: 'Poppins',
            },
          }}
        />
        <Stack.Screen
          name="AddTimeZone"
          component={AddTimeZoneScreen}
          options={{
            headerTitleStyle: {
              fontFamily: 'Poppins',
            },
          }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;