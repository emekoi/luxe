package format.obj;

import format.obj.Data;

class Reader {
    var i : haxe.io.Input;

    var vertexIndices : Array<Int>;
    var uvIndices : Array<Int>;
    var normalIndices : Array<Int>;

    public function new(input) {
        i = input;
        i.bigEndian = true;
    }

    public function read() {
        
        var file_string : String = i.readAll().toString();
        var lines = file_string.split('\n');
        
        var data = parse(lines);

        return data;        
    }

    private function parse( lines : Array<String> )  {

        var data : format.obj.Data = {
            vertices : new Array<format.obj.Vertex>()
        };

        vertexIndices = new Array<Int>();
        normalIndices = new Array<Int>();
        uvIndices = new Array<Int>();

        var temp_verts : Array<format.obj.Vector> = new Array<format.obj.Vector>();
        var temp_uvs : Array<format.obj.UV> = new Array<format.obj.UV>();
        var temp_normals : Array<format.obj.Normal> = new Array<format.obj.Normal>();

        for(line in lines) {
            var type = line.split(' ')[0];
            switch(type) {
                case "v":
                    temp_verts.push( parse_vert(line) );
                case "vt":  
                    temp_uvs.push( parse_uv(line) );
                case "vn":
                    temp_normals.push( parse_normal(line) );
                case "f":
                    parse_face(line);
                case "s":

            }
        }

                    // For each vertex of each triangle
        for( i in 0 ... vertexIndices.length ) {

                // Get the indices of its attributes
                var vertexIndex : Int = vertexIndices[i];
                var uvIndex : Int = uvIndices[i];
                var normalIndex : Int = normalIndices[i];
                
                // Get the attributes thanks to the index
                var pos = temp_verts[ vertexIndex-1 ];
                var uv = temp_uvs[ uvIndex-1 ];
                var normal = temp_normals[ normalIndex-1 ];

                trace('\t pos : ' + pos);
                trace('\t uv : ' + uv);   

                data.vertices.push({
                    pos : pos,
                    uv : uv,
                    normal : normal
                });
        }

        return data;
    }

    private function parse_vert(line:String) : format.obj.Vector {
            
            //note items[0] is the identifier
        var items = line.split(' ');            

        var v : format.obj.Vector = {
            x : Std.parseFloat( items[1] ),
            y : Std.parseFloat( items[2] ),
            z : Std.parseFloat( items[3] )
        };

        return v;
    }

    private function parse_uv(line:String) : format.obj.UV {

            //note items[0] is the identifier
        var items = line.split(' ');

        var uv : format.obj.UV = {
            u : Std.parseFloat( items[1] ),
            v : Std.parseFloat( items[2] )
        };

        return uv;
    }

    private function parse_normal(line:String) : format.obj.Normal {
        
            //note items[0] is the identifier
        var items = line.split(' ');

        var n : format.obj.Normal = {
            x : Std.parseFloat( items[1] ),
            y : Std.parseFloat( items[2] ),
            z : Std.parseFloat( items[3] )
        }

        return n;
    }

    private function parse_face(line:String) {

        var items = line.split(' ');
        
        var vert1 = items[1].split('/');
        var vert2 = items[2].split('/');
        var vert3 = items[3].split('/');

        if(items.length > 4) {
            throw "Can't parse faces that aren't triangulated from here (yet).";
        }

        vertexIndices.push( Std.parseInt(vert1[0]) );
        vertexIndices.push( Std.parseInt(vert2[0]) );
        vertexIndices.push( Std.parseInt(vert3[0]) );

        uvIndices.push( Std.parseInt(vert1[1]) );
        uvIndices.push( Std.parseInt(vert1[1]) );
        uvIndices.push( Std.parseInt(vert1[1]) );

        normalIndices.push( Std.parseInt(vert1[2]) );
        normalIndices.push( Std.parseInt(vert1[2]) );
        normalIndices.push( Std.parseInt(vert1[2]) );

    }

}


