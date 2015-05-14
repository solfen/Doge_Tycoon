package utils.game;

import js.Browser;
import utils.game.Particle;
import pixi.textures.Texture;
import pixi.display.SpriteBatch;
import utils.events.Event;

// Un sytème de particules tout simple
// Hérite de SprtieBatch qui est une version plus rapide de DisplayObjectContainer
class ParticleSystem extends SpriteBatch
{
	private var baseTexture:Texture;
	private var particlesArr:Array<Particle> = [];
	private var visiblesParticles:Int = 0;
	private var particlesNb:Int;
	private var maxSpeed:Float;
	private var minSpeed:Float;
	private var lifeTime:Float;
	private var alphaDeath:Float;


	public function new (frameID:String, ?pParticlesNb:Int = 30,?pMaxSpeed:Float = 400,?pMinSpeed:Float = 200,?pLifeTime:Float = 1.5,?pAlphaDeath:Float = 0){
		super();
		baseTexture = Texture.fromFrame(frameID);
		particlesNb = pParticlesNb;
		maxSpeed = pMaxSpeed;
		minSpeed = pMinSpeed;
		alphaDeath = pAlphaDeath;
		createParticles(particlesNb);
		lifeTime = pLifeTime;
		Main.getInstance().addEventListener(Event.GAME_LOOP, animate);
	}
	private function createParticles(nb){
		for(i in 0...nb){
			var particle:Particle = new Particle(baseTexture);
			particle.visible = false;
			particle.anchor.set(0.5,0.5);
			particlesArr.push(particle);
			addChild(particle);
		}
	}
	public function startParticlesEmission(startX:Float,startY:Float){
		var particlesNeeded:Int = particlesNb - (particlesArr.length - visiblesParticles);
		if(particlesNeeded > 0){
			createParticles(particlesNeeded);
		}

		var partcilesEmited:Int = 0;
		var cpt:Int = 0;
		while(partcilesEmited < particlesNb){
			if(!particlesArr[cpt].visible){
				particlesArr[cpt].position = toLocal(new pixi.geom.Point(startX,startY));
				particlesArr[cpt].speed = (maxSpeed-minSpeed) * Math.random() + minSpeed;
				particlesArr[cpt].direction = Math.random() * Math.PI * 2;
				particlesArr[cpt].visible = true;
				partcilesEmited++;
			}
			cpt++;
		}
		visiblesParticles += partcilesEmited;
	}

	private function animate(){
		var delta = Main.getInstance().delta_time;
		for(particle in particlesArr){
			if(particle.visible){
				particle.x += Std.int(Math.sin(particle.direction) * particle.speed * delta);
				particle.y += Std.int(Math.cos(particle.direction) * particle.speed * delta);
				particle.alpha -= delta*(1-alphaDeath)/lifeTime;

				if(particle.alpha <= alphaDeath){
					particle.alpha = 1;
					particle.visible = false;
					visiblesParticles--;
				}
			}
		}
	}

	public function destroy(){
		Main.getInstance().removeEventListener(Event.GAME_LOOP,animate);
	}

}