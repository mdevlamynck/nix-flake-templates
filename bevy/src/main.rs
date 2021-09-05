use bevy::prelude::*;

#[bevy_main]
fn main() {
    App::build()
        .add_plugins(DefaultPlugins)
        .add_plugin(GamePlugin)
        .run();
}

// Sample game code with unit test

pub struct GamePlugin;

impl Plugin for GamePlugin {
    fn build(&self, app: &mut AppBuilder) {
        app.add_startup_system(create_ball.system())
            .add_system(move_ball.system());
    }
}

#[derive(Bundle)]
pub struct BallBundle {
    ball:     Ball,
    position: Position,
    velocity: Velocity,
}

pub struct Ball;

pub struct Position(Vec2);

pub struct Velocity(Vec2);

fn create_ball(mut commands: Commands) {
    commands.spawn_bundle(BallBundle {
        ball:     Ball,
        position: Position(Vec2::ZERO),
        velocity: Velocity(Vec2::ONE),
    });
}

fn move_ball(mut query: Query<(&mut Position, &Velocity), With<Ball>>) {
    for (mut position, velocity) in query.iter_mut() {
        position.0 += velocity.0;
    }
}

#[cfg(test)]
mod tests {
    use bevy::prelude::*;

    use super::*;

    fn setup(setup_fn: impl FnOnce(&mut AppBuilder)) -> (World, Schedule) {
        let mut builder = App::build();
        setup_fn(&mut builder);

        let App {
            schedule, world, ..
        } = builder.app;

        (world, schedule)
    }

    #[test]
    fn spawn_and_move_ball() {
        let (mut world, mut schedule) = setup(|builder| {
            builder.add_plugin(GamePlugin);
        });

        schedule.run(&mut world);

        let mut query = world.query_filtered::<&Position, With<Ball>>();
        let ball_position = query.iter(&world).next().expect("Spawned Ball");
        assert_eq!(Vec2::ONE, ball_position.0);
    }
}
