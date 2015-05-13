package utils.game;

import pixi.filters.AbstractFilter;

/**
 * Ported from http://www.html5gamedevs.com/topic/10640-outline-a-sprite-change-certain-colors/
 * @author Lucien Boudy
 */

class OutlineFilter extends AbstractFilter
{
	private var _fragment_src: Array<String>;
	private var _uniforms: Dynamic = {
		thickness:		{ type: '1f', value: null },
		outlineColor:	{ type: '4f', value: null },
		pixelWidth:		{ type: '1f', value: null },
		pixelHeight:	{ type: '1f', value: null },
    };

	public function new (pViewWidth: Int, pViewHeight: Int, pThickness: Float, pColor: Int): Void 
	{
		set_thickness(pThickness);
		set_outlineColor(pColor);
		set_pixelWidth(pViewWidth);
		set_pixelHeight(pViewHeight);

		_fragment_src = [

			'precision mediump float;',
			'varying vec2 vTextureCoord;',
			'uniform sampler2D texture;',
			'uniform float thickness;',
			'uniform vec4 outlineColor;',
			'uniform float pixelWidth;',
			'uniform float pixelHeight;',
			'vec2 px = vec2(pixelWidth, pixelHeight);',

			'void main (void) {',
			'    if (thickness < .5) {',
			'        gl_FragColor = texture2D(texture, vTextureCoord);',
			'	} else {',
			'        const float PI = 3.14159265358979323846264;',
			'        vec4 ownColor = texture2D(texture, vTextureCoord);',
			'        vec4 curColor;',
			'        float maxAlpha = 0.;',
			'        for (float angle = 0.; angle < PI * 2.; angle += 0.5 ) {',
			'            curColor = texture2D(texture, vec2(vTextureCoord.x + thickness * px.x * cos(angle), vTextureCoord.y + thickness * px.y * sin(angle)));',
			'            maxAlpha = max(maxAlpha, curColor.a);',
			'        }',
			'        float resultAlpha = max(maxAlpha, ownColor.a);',
			'        gl_FragColor = vec4((ownColor.rgb + outlineColor.rgb * (1. - ownColor.a)) * resultAlpha, resultAlpha);',
			'    }',
			'}'
		];

		super(_fragment_src, _uniforms);

		dirty = true;
	}

	public function set_thickness (pThickness: Float) : Void
	{
		_uniforms.thickness.value = pThickness;
	}

	public function set_outlineColor (pColor: Int, ?pAlpha: Float) : Void
	{
		var r: Float = ((pColor & 0xFF0000) >> 16) / 255;
		var g: Float = ((pColor & 0x00FF00) >> 8) / 255;
		var b: Float = (pColor & 0x0000FF) / 255;

		_uniforms.outlineColor.value = {
			x: r,
			y: g,
			z: b,
			w: pAlpha != null ? pAlpha : 1 // pas encore pris en compte dans le shader
		};
	}

	public function set_pixelWidth (pViewWidth: Int) : Void
	{
		_uniforms.pixelWidth.value = 1 / pViewWidth;
	}

	public function set_pixelHeight (pViewHeight: Int) : Void
	{
		_uniforms.pixelHeight.value = 1 / pViewHeight;
	}

}