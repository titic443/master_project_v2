import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/widgets/slider_demo_cubit.dart';

class SliderDemoPage extends StatelessWidget {
  const SliderDemoPage({super.key});

  static const route = '/slider-demo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderDemoCubit(),
      child: const _SliderDemoForm(),
    );
  }
}

class _SliderDemoForm extends StatelessWidget {
  const _SliderDemoForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider Widget Demo'),
      ),
      body: BlocBuilder<SliderDemoCubit, SliderDemoState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Volume Slider
                const Text(
                  'Volume',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  key: const Key('slider_01_volume_slider'),
                  value: state.volume,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: state.volume.round().toString(),
                  onChanged: (value) {
                    context.read<SliderDemoCubit>().onVolumeChanged(value);
                  },
                ),
                Text(
                  key: const Key('slider_02_volume_text'),
                  'Current: ${state.volume.round()}%',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Brightness Slider
                const Text(
                  'Brightness',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  key: const Key('slider_03_brightness_slider'),
                  value: state.brightness,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: state.brightness.round().toString(),
                  onChanged: (value) {
                    context.read<SliderDemoCubit>().onBrightnessChanged(value);
                  },
                ),
                Text(
                  key: const Key('slider_04_brightness_text'),
                  'Current: ${state.brightness.round()}%',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Temperature Slider
                const Text(
                  'Temperature',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  key: const Key('slider_05_temperature_slider'),
                  value: state.temperature,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: '${state.temperature.round()}°C',
                  onChanged: (value) {
                    context.read<SliderDemoCubit>().onTemperatureChanged(value);
                  },
                ),
                Text(
                  key: const Key('slider_06_temperature_text'),
                  'Current: ${state.temperature.round()}°C',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
